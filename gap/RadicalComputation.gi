#############################################################################
##
##  RadicalComputation.gi                       PrimaryDecomposition package
##
##  Copyright 2013,      Mohamed Barakat, University of Kaiserslautern
##                  Eva Maria Hemmerling, University of Kaiserslautern
##
##  Implementation of some functions for radical computation.
##
#############################################################################

####################################
#
# methods for attributes:
#
####################################

##
InstallMethod( PreparationForRadicalOfIdeal,
	"for an ideal",
	[ IsFinitelyPresentedSubmoduleRep and ConstructedAsAnIdeal ],
	
  function( I )
    local A, R, indets, J, deg, list, M, i, d;
    
    A := HomalgRing( I );
    
    ## step 1 and 2:
    R := A / I ;
    
    indets := Indeterminates( R );
    
    J := List( indets, a -> SeparablePart( MinimalPolynomial( a ) ) );
    
    if not IsPerfect( CoefficientsRing( A ) ) then
        
        J := PolysOverTheSameRing( J );
                
        A := CoefficientsRing( HomalgRing( J[1] ) ) * List( Indeterminates( A ), Name );
        
        A!.RootOfBaseField := HomalgRing( J[1] )!.RootOfBaseField;
        
        list := EntriesOfHomalgMatrix( MatrixOfSubobjectGenerators( I ) );
        
        HomalgRing( list[1] )!.RootOfBaseField:=0;
        
        ## added the one of the ring A to transfer the polynomials into the right ring.
        Add( list, One( A ) );
        list := PolysOverTheSameRing( list );
        list := List( [ 1 .. Length( list ) - 1 ] , i -> list[i] / A );
        
        I := LeftSubmodule( list, A );
        
        R := A / I;
        
        R!.RootOfBaseField := A!.RootOfBaseField;
        
    fi;
    
    indets := List( indets, a -> a / R );
    
    J := List( [ 1 .. Length( J ) ], i -> Value( J[i], indets[i] ) );
    
    J := HomalgMatrix( J, Length( J ), 1, A );
    
    ## step 3 and 4:
    J := AppendToGroebnerBasisOfZeroDimensionalIdeal( R * J );
    
    J := LeftSubmodule( EntriesOfHomalgMatrix( J ), A );
    
    if IsPerfect( CoefficientsRing( A ) ) then
        return J;
    fi;
    
    ## step 5:
    return [ FGLMdata( HomalgRing( J ) / J ), I ];
    
end );

##
InstallMethod( RadicalOfIdeal,
	"for a an ideal",
	[  IsHomalgModule ],

  function( I )
    local A, p, M, J, deg, R, x, C, K, ratios, i, f, FGLM;  
    
    A := HomalgRing( I );
    
    if IsPerfect( CoefficientsRing( A ) ) then
        return PreparationForRadicalOfIdeal( I );
    fi;
    
    p := PreparationForRadicalOfIdeal( I );
    
    M := p[1];
    J := p[2];
    
    A := HomalgRing( J );
    
    R := A / J;
    
    deg := A!.RootOfBaseField;
    
    ## Needed to compute the matrix embedding concerning the field extension.
    x := UnusedVariableName( CoefficientsRing( A ), "x" );
    
    C := CoefficientsRing( A );
    
    K := C * x;
    
    x := Indeterminates( K )[1];
    
    p := Characteristic( C );
    
    ratios := RationalParameters( A );
    
    ## Computing recursily the matrix embedding of the FGLM matrices into the
    ## matrix space over the old field.
    if not IsZero( deg ) then
    
        for i in [ 1 .. Length( ratios ) ] do
        
            f := ( x^p )^deg - ratios[i] / K;
            
            M := List( M, i -> MatrixEmbedding( i , f ) );
        
        od;
        
    fi;
    
    FGLM := FGLMToGroebner( M, CertainRows( HomalgIdentityMatrix( NrRows( M[1] ), \
            HomalgRing( M[1] ) ) , [1] ), List( Indeterminates( A ), Name ) )[2];
    
    return LeftSubmodule( FGLM, HomalgRing( I ) );
    
end );

