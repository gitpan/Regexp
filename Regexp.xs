/*
  Copyright (c) 1997 Nick Ing-Simmons. All rights reserved.
  This program is free software; you can redistribute it and/or
  modify it under the same terms as Perl itself.
*/

#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#define DEFAULT_SCALAR GvSV(defgv)

#define Regexp_pattern(re) ((re)->precomp)

MODULE = Regexp	PACKAGE = Regexp	PREFIX=Regexp_

char *
Regexp_pattern(re)
regexp *	re

MODULE = Regexp	PACKAGE = Regexp

void
parentheses(re)
regexp *	re
PPCODE:
 {
  if (GIMME & G_ARRAY)
   {int i;
    for (i=0; i <  re->nparens; i++)
     {
      SV *sv = sv_newmortal();
      sv_setpvn(sv,re->startp[i],re->endp[i] - re->startp[i]);
      XPUSHs(sv);
     }
    XSRETURN(re->nparens);
   }
  else
   {
    XSRETURN_IV(re->nparens);
   }
 }

void
prematch(re)
regexp *	re
PPCODE:
 {
  ST(0) = sv_newmortal();
  sv_setpvn(ST(0),re->subbeg,re->startp[0] - re->subbeg);
  XSRETURN(1);
 }

void
postmatch(re)
regexp *	re
PPCODE:
 {
  ST(0) = sv_newmortal();
  sv_setpvn(ST(0),re->endp[0],re->subend- re->endp[0]);
  XSRETURN(1);
 }

regexp *
current(class)
char *	class
CODE:
 {
  RETVAL = (curpm) ? curpm->op_pmregexp : NULL;
 }
OUTPUT:
  RETVAL

regexp *
new(class,pattern,options = NULL)
char *	class
SV   *	pattern
char *	options
CODE:
 {
  regexp *re;
  PMOP pm;
  STRLEN len;
  char *s = SvPV(pattern,len);
  Zero(&pm,1,PMOP);
  RETVAL = pregcomp(s,s+len,&pm);
 }
OUTPUT:
  RETVAL

void
match(re, string = DEFAULT_SCALAR, offset = 0, minmatch = 0)
regexp *	re
SV *		string
IV		offset
IV		minmatch 
PPCODE:
{
 STRLEN len;
 char *ptr = SvPV(string,len);
 SV *scream = (0 && SvSCREAM(string)) ? string : Nullsv;
 if (pregexec(re,ptr+offset,ptr+len,ptr,minmatch,scream,1))
  {
   XSRETURN_YES;
  }
 else
  {
   XSRETURN_NO;
  }
}


void
DESTROY(re)
regexp *	re
PPCODE:
 {
  pregfree(re);
 }
