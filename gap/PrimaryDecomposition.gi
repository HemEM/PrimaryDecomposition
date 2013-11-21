#############################################################################
##
##  PrimaryDecomposition.gi                     PrimaryDecomposition package
##
##  Copyright 2013,      Mohamed Barakat, University of Kaiserslautern
##                  Eva Maria Hemmerling, University of Kaiserslautern
##
##  Implementation of some functions for primary decomposition.
##
#############################################################################

####################################
#
# methods for attributes:
#
####################################

##
InstallMethod( IsPrimeZeroDim,
	"for a zero dimensional ideal",
	[ IsFinitelyPresentedSubmoduleRep and ConstructedAsAnIdeal ],
	
  function( I )
    local A, C, R, indets, mu, sf_mu, degI, i, RadI, n, RmodRadI, degRadI, e, L, iter, 
          lambda, z, w, comb, bool, l, W, Wext;
    
    A := HomalgRing( I );
    
    C := CoefficientsRing( A );
    
    ## preliminary test for perfectness, should be replaced by IsPerfect
    if not IsPerfect( C ) then
        TryNextMethod( );
    fi;
    
    ## The first part of the algorithm computes the minimal polynomials of the 
    ## indeterminates of R and determines if at least one of them is irreducible 
    ## of degree dim_C( R/I ) or reducible. In the first case this element proves
    ## that the ideal I is a prime ideal, in the second case the ideal I cannot be
    ## a prime ideal.
    
    R := A / I;
    
    indets := Indeterminates( R );
    
    mu := List( indets, MinimalPolynomial );
    
    sf_mu := List( mu, SquareFreeFactors );
    
    degI := NrRows( BasisOverCoefficientsRing( R ) );
    
    for i in [ 1 .. Length( mu ) ] do
        if Length( sf_mu[i] ) > 1 then
            I!.AZeroDivisor := indets[i];
            return false;
        elif Degree( sf_mu[i][1] ) < Degree( mu[i] ) then
            I!.AZeroDivisor := indets[i];
            I!.ANilpotentElement := indets[i];
            return false;
        elif Degree( sf_mu[i][1] ) = degI then
            return true;
        fi;
    od;
    
    ## Now the algorithms asks if I is a radical ideal.
    ## If yes, it is a prime ideal. If not, then I cannot be a prime ideal.
    
    RadI := RadicalOfIdeal( I );
    
    if not IsSubset( I, RadI ) then
        return false;
    fi;
        
    ## The last part of the algorithm computes witness elements. 
    ## Splitted in two cases: The coefficients ring is finite or not.
    
    ## Some values needed in both cases:
    
    RmodRadI := A / RadI;
    
    degRadI := NrRows( BasisOverCoefficientsRing( RmodRadI ) );
    
    n := Length( indets );
    
    e := HomalgIdentityMatrix( n, C );
    
    indets := HomalgMatrix( indets, Length( indets ), 1, R );
    
    ## First case: Coefficients ring is finite.
    
    if IsFinite( C ) then
        
        ## After initializing an iterator the algorithm repeats the loop until
        ## a suitable element has fulfilled the asked properties.
        L := [];
        L := List( [ 1 .. n ], i -> CertainRows( e, [i] ) );
        
        iter := Iterator( e );
        
        lambda := NextIterator( iter );  ## The zero element will be left out.
        
        while true do
            
            lambda := NextIterator( iter );

            if Position( L, lambda )= fail then
                
                w := ( R * lambda ) * indets;
                
                mu := MinimalPolynomial( w );
            
                if IsIrreducible( mu ) and Degree( mu ) = degRadI then
                
                    return true;
                
                elif not IsIrreducible( mu ) then
                
                    I!.AZeroDivisor := w;
                    return false;
                
                fi;
                
                Add( L , lambda);
                
            fi;
                        
        od;
        
    fi;
    
    ## Second case: Coefficients ring is not finite.
    L := e;
    
    while true do
        
        lambda := GeneratorOfAnElementNotContainedInAnyHyperplane( L );
        
        w := ( R * lambda ) * indets;
            
        mu := MinimalPolynomial( w );
        
        if IsIrreducible( mu ) and Degree( mu ) = degRadI then
            
            return true;
            
        elif not IsIrreducible( mu ) then
        
            I!.AZeroDivisor := w;
            return false;
        
        fi;
        
        Add( L, lambda );
        
    od;
    
end );

##
InstallMethod ( IsPrimaryZeroDim,
	"for a zero dimensional ideal",
	[ IsFinitelyPresentedSubmoduleRep and ConstructedAsAnIdeal ],
        
  function( I )
    local bool, Rad;
    
    Rad := RadicalOfIdeal( I );
    
    bool := IsPrimeZeroDim( Rad );
        
    if IsBound( Rad!.ZeroDivisor ) then
        I!.AZeroDivisor := Rad!.AZeroDivisor;
    fi;
    
    if IsBound( Rad!.ANilpotentElement ) then
        I!.ANilpotentElement := Rad!.ANilpotentElement;
    fi;
    
    return bool;
    
end );

##
InstallMethod( PrimaryDecompositionZeroDim,
        [ IsHomalgObject ],

  function( I )
    local Decomp, Rad, a, fac, N, W, i, A, R, bas, J, j, M;
    
    Decomp := []; 
    
    ## If I is already primary, then the algorithmus returns I itself.
    
    if IsPrimaryZeroDim( I ) then
        Decomp[ 1 ] := I;
        return Decomp;
    fi;
    
    ## If the ideal I is not primary, then the algorithmus asks if IsPrimaryZeroDim has
    ## found a zerodivisor. If yes, then it decomposes the ideal.
    
    if IsBound( I!.AZeroDivisor ) then
        a := I!.AZeroDivisor;
    fi;
    
    fac := PrimaryDecomposition( LeftSubmodule( MinimalPolynomial( a ) ) );
    fac := List( [ 1 .. Length( fac ) ], i -> MatrixOfSubobjectGenerators( fac[ i ][ 1 ]) );
    fac := List( [ 1 .. Length( fac ) ], i -> MatElm( fac[ i ], 1 ,1 ) );
    
    N := [ ];
    W := [ ];
    
    A := HomalgRing( I );
    R := A / I;
    
    bas := BasisOverCoefficientsRing( R );
    
    a := a / R;
    
    for i in [ 1 .. Length( fac ) ] do
        N[ i ] := RepresentationOverCoefficientsRing( Value( fac[ i ] , a ) );
        W[ i ] := SyzygiesOfRows( N[i] ) * R;
    od;
    
    J := Iterated( W, UnionOfRows );
    
    M := [ ];
    
    j := [ ];
    j[ 1 ] := 0;
    
    for i in [ 1 .. Length( fac ) ] do
        
        j[ i + 1 ] := j[ i ] + NrRows( W[ i ] );
        M[ i ] := UnionOfRows( CertainRows( J , [ 1 .. j[i] ] ), CertainRows( J, [ j[ i + 1 ] + 1 .. NrRows( J ) ] ) );
        # M[ i ] := IdealBasisToGroebner( ( M[ i ] ) );
        
        M[ i ] := LeftSubmodule( BasisOfRows( M[ i ] ) );
        M[ i ] := UnionOfRows( A * MatrixOfGenerators( I ), A *( M[ i ] * bas ) );
        
        if not IsOne( M[ i ] ) then
            Append( Decomp, PrimaryDecompositionZeroDim( M[ i ] ) );
        fi;
    od;
    
    return Decomp;

end );
