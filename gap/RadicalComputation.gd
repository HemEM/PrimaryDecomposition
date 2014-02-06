#############################################################################
##
##  RadicalComputation.gd                       PrimaryDecomposition package
##
##  Copyright 2013,      Mohamed Barakat, University of Kaiserslautern
##                  Eva Maria Hemmerling, University of Kaiserslautern
##
##  Declaration of some functions for radical computation.
##
#############################################################################

#! @Chapter Radical Computation

####################################
#
#! @Section Attributes
#
####################################

#! @Description
#!  Computes the radical of an ideal if the coefficients field is perfect
#!  and otherwise computes the FGLM data of the ideal <M>J</M> which is
#!  generated by the separable parts of the minimal polynomials of the
#!  indeterminates evaluated at the indeterminates of the ring over the
#!  field extension needed for the separable part.
#! @Arguments I
#! @Returns an Ideal
DeclareAttribute( "PreparationForRadicalOfIdeal",
	IsHomalgModule );

#! @Description
#!  Computes the radical of a zero dimensional ideal <A>I</A>. 
#! @Arguments I
#! @Returns an Ideal
DeclareAttribute( "RadicalOfIdeal",
	IsHomalgModule );
#! @InsertSystem RadicalOfIdeal


