#############################################################################
##
##  Tools.gd                                    PrimaryDecomposition package
##
##  Copyright 2013,      Mohamed Barakat, University of Kaiserslautern
##                  Eva Maria Hemmerling, University of Kaiserslautern
##
##  Declaration of some tools.
##
#############################################################################

#! @Chapter Tools

####################################
#
#! @Section Attributes
#
####################################

#! @Description
#!  Computes a basis of the ring <A>R</A>,
#!  provided it is free of finite rank over its coefficients ring.
#! @Arguments R
#! @Returns a &homalg; matrix
DeclareAttribute( "BasisOverCoefficientsRing",
        IsHomalgRing );
#! @InsertSystem BasisOverCoefficientsRing

#! @Description
#!  Computes a representation matrix of the ring element <A>r</A>,
#!  with respect to the basis computed by BasisOverCoefficientsRing,
#!  provided the ring is free of finite rank over its coefficients ring.
#! @Arguments r
#! @Returns a &homalg; matrix
DeclareAttribute( "RepresentationOverCoefficientsRing",
        IsHomalgRingElement );
#! @InsertSystem RepresentationOverCoefficientsRing

#! @Description
#!  Computes the FGLM data of the ring <A>R</A> (see <Cite Key="SJ"/>),
#!  provided it is free of finite rank over its coefficients ring.
#!  The FGLM data of such a ring consists of the representation matrices
#!  of all indeterminates of <A>R</A> computed by
#!  RepresentationOverCoefficientsRing.
#! @Arguments R
#! @Returns a list
DeclareAttribute( "FGLMdata",
        IsHomalgRing );
#! @InsertSystem FGLMdata

#! @Description
#!  Computes the minimal polynomial of the element <A>r</A>
#!  of a ring <M>R</M> of finite rank over its coefficients ring.
#!  @InsertChunk MinimalPolynomial_ring_element
#! @Arguments r
#! @Returns a matrix
#! @Group MinimalPolynomial
DeclareAttribute( "MinimalPolynomial",
	IsHomalgRingElement );
#! @InsertSystem MinimalPolynomial

#! @Description
#!  Computes the irreducible factors of the square free part of the 
#!  univariate polynomial <A>p</A>.
#! @Arguments p
#! @Returns a list
DeclareAttribute( "SquareFreeFactors",
	IsHomalgRingElement );
#! @InsertSystem SquareFreeFactors

#! @Description
#!  Computes the separable part of a univariate polynomial <A>p</A>.
#!  @InsertChunk SeparablePart_info
#! @Arguments p
#! @Returns a ring element
DeclareAttribute( "SeparablePart",
	IsHomalgRingElement );
#! @InsertSystem SeparablePart

#! @Arguments r
#! @Returns a matrix
#! @Description
#!  Computes the coefficients of the basis representation of <A>r</A>,
#!  provided the ring is free of finite rank over its coefficients ring.
DeclareAttribute( "BasisCoefficientsOfRingElement",
	IsHomalgRingElement);
#! @InsertSystem BasisCoefficientsOfRingElement

#! @Arguments G
#! @Returns a matrix
#! @Description
#!  Computes a <M>K</M>-basis of an ideal generated by the entries of the matrix
#!  <A>G</A> over <M>R</M>, where <M>K</M> is the coefficient ring of <M>R</M>,
#!  using an algorithm of Sebastian Jambor (see <Cite Key="SJ"/>).
DeclareOperation( "IdealBasisOverCoefficientRing", 
	[ IsHomalgMatrix ] );
#! @InsertSystem IdealBasisOverCoefficientsRing

#! @Arguments K
#! @Returns a ring
#! @Description
#!  Computes an isomorphic, GAP internal ring.
DeclareAttribute( "GapInternalIsomorphicRing",
	IsHomalgRing);

#! @Description
#!  Computes a Groebner basis of an ideal <M> I \unlhd R </M> defined by a 
#!  <M>K</M>-basis of an ideal <M>J \unlhd R/\tilde{I}</M>, where <M>K</M>
#!  is the coefficients ring and <M>\tilde{I}</M> a zero dimensional ideal. 
#!  The basis elements are given in the rows of the matrix <A>M</A> in form
#!  of coefficient vectors with respect to the basis of the ring, which is
#!  computed by BasisOverCoefficientsRing and the matrix is defined over
#!  <M>R/\tilde{I}</M>. This method works only for perfect coefficients
#!  rings <M>K</M>, since the reduced echelon form only accepts GAP internal
#!  rings.
#!  The method is based on an algorithm of Sebastian Jambor (see <Cite Key="SJ"/>).
#! @Arguments M
#! @Returns a list
DeclareAttribute( "IdealBasisToGroebner", 
	IsHomalgMatrix);
	
#! @Description
#!  Computes a Groebner Basis of the ideal generated by the 
#!  entries of the matrix <A>G</A> and the generators of the defining zero 
#!  dimensional ideal of the residue class ring over which <A>G</A> is defined.
#!  @InsertChunk AppendToGroebner_info
#! @Arguments G
#! @Returns a matrix
DeclareAttribute( "AppendToGroebnerBasisOfZeroDimensionalIdeal", 
	IsHomalgMatrix );
#! @InsertSystem AppendToGroebnerBasisOfZeroDimensionalIdeal
	
#! @Arguments f
#! @Returns a ring element
#! @Description
#!  Computes the derivative of the univariate polynomial <A>f</A>.
DeclareAttribute( "Derivative", 
	IsHomalgRingElement);
#! @InsertSystem Derivative

####################################
#
#! @Section Operations
#
####################################

#! @Arguments r, str
#! @Group MinimalPolynomial
DeclareOperation( "MinimalPolynomial",
	[ IsHomalgRingElement, IsString ] );

#! @Arguments r, t
#! @Group MinimalPolynomial
DeclareOperation( "MinimalPolynomial",
	[ IsHomalgRingElement, IsHomalgRingElement ] );

#! @Description
#!  Determines whether <A>lambda</A> is contained in any <M>n - 1 </M> dimensional 
#!  subspace spanned by the rows of  <A>L</A>.
#! @Arguments lambda, L
#! @Returns a matrix
DeclareOperation( "IsNotContainedInAnyHyperplane",
	[IsHomalgMatrix, IsHomalgMatrix ] );
#! @InsertSystem IsNotContainedInAnyHyperplane
	
#! @Description
#!  Generates an element of <M>K^n</M>, which is not contained in any <M>n - 1</M> 
#!  dimensional subspace of the vector field <M>K^n</M>, respectively <M>C^n</M>,
#!  spanned by the rows of <A>L</A>. The method repeats generating a random 
#!  vector <M>\lambda \in K^n</M> until the method IsNotContainedInAnyHyperplan 
#!  of <M>\lambda</M> and <A>L</A> returns TRUE.
#! @Group GeneratorOfAnElement
#! @Arguments L
#! @Returns a value
DeclareOperation( "GeneratorOfAnElementNotContainedInAnyHyperplane",
	[ IsHomalgMatrix ] );
#! @InsertSystem GeneratorOfAnElementNotContainedInAnyHyperplane

#! @Arguments L, C
#! @Group GeneratorOfAnElement
DeclareOperation( "GeneratorOfAnElementNotContainedInAnyHyperplane",
	[ IsHomalgMatrix, IsHomalgRing ] );

#! @Arguments M, e
#! @Returns two lists
#! @Group FGLMToGroebner
#! @Description
#!  Computes a basis of the residue class ring and a Groebner Basis of the
#!  defining ideal, both defined by the FGLM data <A>M</A> and the identity 
#!  element <A>e</A>. The method uses an algorithm of Sebastian Jambor
#!  (see <Cite Key="SJ"/>).
DeclareOperation( "FGLMToGroebner", 
	[ IsList, IsHomalgMatrix ] );
#! @InsertSystem FGLMToGroebner

#! @Arguments M, e, l
#! @Group FGLMToGroebner
DeclareOperation( "FGLMToGroebner", 
	[ IsList, IsHomalgMatrix, IsList ] );
