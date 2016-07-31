#! /usr/bin/env runhaskell

> import Distribution.Simple (defaultMainWithHooks)
> import Distribution.Simple.UUAGC (uuagcLibUserHook)
> import UU.UUAGC (uuagc)
> 
> -- | Better than depending on a Makefile for this.
> main = defaultMainWithHooks (uuagcLibUserHook uuagc)