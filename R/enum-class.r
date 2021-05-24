#' `enum` class
#'
#' @description
#'
#' The `enum` class is inspired by enumerated types in other languages,
#' and draws much of its functionality from the primitive list class.
#'
#' Generally, enums are more restrictive than lists, with the intent of
#' promoting self-documenting code. They do not allow duplicate values
#' or names, nor do they allow enum values to be changed later.
#'
#' In essence, an enum can be thought of as a dictionary of values, which
#' can be referenced later down the road with the assurance that the related
#' value will *never* change.
#'
#' The enum class is the parent of numeric and generic enums, and will always
#' exist alongside one of the child classes. Which child class an enum will
#' inherit is (generally) decided at run time.
#'
#' See the [pkgdown site](https://elianhugh.github.io/enumr/index.html) for
#' more information.
#'
#' @section Generic Enums:
#'
#' Generic enums have:
#' * Class attribute of `enum` and `generic_enum`
#' * Unique name/value pairs
#' * Explicitly defined values
#' * Any type of value
#'
#' @section Numeric Enums:
#'
#' Numeric enums have:
#' * Class attribute of `enum` and `numeric_enum`
#' * Unique name/value pairss
#' * Either explicit or implicitly defined values
#' * All numeric values
#'
#' Implicit values are created when a name is passed to the enum constructor
#' without a value associated with it. The constructor will then assign the name
#' a value, which is either:
#'    * Plus one to the previous index's value
#'    * The index of the name
#'
#' @section How enums differ from lists:
#'
#' |                            	|   List  	|          Enum          	|
#' |----------------------------	|:-------:	|:----------------------:	|
#' | Primitive                  	| &#9745; 	|            x           	|
#' | Static                     	|    x    	|         &#9745;        	|
#' | Allow duplicate names      	| &#9745; 	|            x           	|
#' | Allow duplicate values     	| &#9745; 	|            x           	|
#' | Allow values without names 	| &#9745; 	|            x           	|
#' | Implicit definition        	|    x    	| &#9745;(Numeric enums) 	|
#'
#' @name enum-class
#' @aliases numeric_enum generic_enum
#' @seealso [enum()], [as_enum()], [print.enum()]
NULL
