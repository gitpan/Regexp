/*
  Copyright (c) 1997 Nick Ing-Simmons. All rights reserved.
  This program is free software; you can redistribute it and/or
  modify it under the same terms as Perl itself.
*/

#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#ifdef __cplusplus
}
#endif

#ifndef H_PERLIO
#define OutputStream FILE *
#define PerlIO_printf fprintf
#define PerlIO_putc(io,ch) putc(ch,io)
#define PerlIO_stderr() stderr
#endif

#define DEFAULT_SCALAR GvSV(defgv)

#define Const_FOLD()	   (PMf_FOLD)
#define Const_SINGLELINE() (PMf_SINGLELINE)
#define Const_MULTILINE()  (PMf_MULTILINE)
#define Const_KEEP()	   (PMf_KEEP)
#define Const_GLOBAL()	   (PMf_GLOBAL)
#define Const_NOCASE()	   (PMf_FOLD)
#define Const_EXTENDED()   (PMf_EXTENDED)
#define Const_EVAL()	   (PMf_EVAL)

#define Regexp_nparens(rx) ((rx)->nparens)
#define Regexp_lastparen(rx) ((rx)->lastparen)
#define Regexp_minlength(rx) ((rx)->minlen)

MODULE = Regexp	PACKAGE = Regexp	PREFIX=Const_

I32
Const_FOLD(...)
PROTOTYPE:

I32
Const_SINGLELINE(...)
PROTOTYPE:

I32
Const_MULTILINE(...)
PROTOTYPE:

I32
Const_KEEP(...)
PROTOTYPE:

I32
Const_GLOBAL(...)
PROTOTYPE:

I32
Const_NOCASE(...)
PROTOTYPE:

I32
Const_EXTENDED(...)
PROTOTYPE:

I32
Const_EVAL(...)
PROTOTYPE:

MODULE = Regexp	PACKAGE = Regexp	PREFIX=Regexp_

I32
Regexp_nparens(re)
    regexp *	re

I32
Regexp_minlength(re)
    regexp *	re

I32
Regexp_lastparen(re)
    regexp *	re

MODULE = Regexp	PACKAGE = Regexp

void
pattern(re)
    regexp *	re
PPCODE:
{
    if(re->precomp) {
	ST(0) = sv_newmortal();
	sv_setpvn(ST(0), re->precomp, re->prelen);
    }
    else
	ST(0) = &sv_undef;

    XSRETURN(1);
}

void
backref(re,index = -1)
    regexp *	re
    int		index
PPCODE:
{
    if (items == 2) {
	if(index >= 0 && index <= re->nparens && re->startp[index] != Nullch) {
	    ST(0) = sv_newmortal();
	    sv_setpvn(ST(0),re->startp[index],
		re->endp[index] - re->startp[index]);
	}
	else
	    ST(0) = &sv_undef;
	XSRETURN(1);
    }
    else if (GIMME & G_ARRAY) {
	int i;
	for (i=1; i <= re->nparens; i++) {
	    SV *sv;
	    if(re->startp[i]) {
		sv = sv_newmortal();
		sv_setpvn(sv,re->startp[i],re->endp[i] - re->startp[i]);
	    }
	    else
		sv = &sv_undef;

	    XPUSHs(sv);
	}
	XSRETURN(re->nparens);
    }
    else {
	XSRETURN_IV(re->nparens);
    }
}

void
prematch(re)
    regexp *	re
PPCODE:
{
    if(re->startp[0]) {
	ST(0) = sv_newmortal();
	sv_setpvn(ST(0),re->subbeg,re->startp[0] - re->subbeg);
    }
    else
	ST(0) = &sv_undef;
    XSRETURN(1);
}

void
postmatch(re)
    regexp *	re
PPCODE:
{
    if(re->startp[0]) {
	ST(0) = sv_newmortal();
	sv_setpvn(ST(0),re->endp[0],re->subend - re->endp[0]);
    }
    else
	ST(0) = &sv_undef;
    XSRETURN(1);
}

void
lastmatch(re)
    regexp *	re
PPCODE:
{
    if(re->startp[0]) {
	ST(0) = sv_newmortal();
	sv_setpvn(ST(0),re->startp[0],re->endp[0] - re->startp[0]);
    }
    else
	ST(0) = &sv_undef;
    XSRETURN(1);
}

void
length(re)
    regexp *	re
PPCODE:
{
    XSRETURN_IV(re->endp[0] - re->startp[0]);
}

void
endpos(re)
    regexp *	re
PPCODE:
{
    XSRETURN_IV(re->endp[0] - re->subbeg);
}

void
startpos(re)
    regexp *	re
PPCODE:
{
    XSRETURN_IV(re->startp[0] - re->subbeg);
}

regexp *
new(class,pattern,pmflags = 0)
    char *	class
    SV   *	pattern
    U16		pmflags
CODE:
{
    regexp *re;
    PMOP pm;
    STRLEN len;
    char *s = SvPV(pattern,len);
    Zero(&pm,1,PMOP);
    pm.op_pmflags = pmflags;
    RETVAL = pregcomp(s,s+len,&pm);
}
OUTPUT:
    RETVAL

void
match(re, string = DEFAULT_SCALAR, offset = 0, flags = 0)
    regexp *	re
    SV     *	string
    IV		offset
    IV		flags 
PPCODE:
{
    STRLEN len;
    char *ptr = SvPV(string,len);
    int matches = 0;

    while (pregexec(re,ptr+offset,ptr+len,ptr,0,Nullsv,1)) {
	if (GIMME & G_ARRAY) {
	    int i;

	    matches += re->nparens;

	    EXTEND(sp, re->nparens);

	    for (i=1; i <= re->nparens; i++) {
		if (re->endp[i]) {
		    SV *sv = sv_newmortal();
		    sv_setpvn(sv, re->startp[i], re->endp[i] - re->startp[i]);
		    XPUSHs(sv);
		}
		else {
		    XPUSHs(&sv_undef);
		}
	    }
	}
	else {
	    matches = 1;
	}

	if(!(flags & PMf_GLOBAL))
	    break;

	offset = re->endp[0] - re->subbeg;
    }

    if (GIMME & G_ARRAY) {
	EXTEND(sp,0);
	XSRETURN(matches);
    }

    if(matches)
	XSRETURN_YES;

    XSRETURN_NO;
}

void
regdump(re)
    regexp *	re
CODE:
{
#ifdef DEBUGGING
    regdump(re);
#else
    warn("Compile perl with DEBUGGING to dump regexp's");
#endif
}

#if 0
#define _ We use the SVf_BREAK flag here to annotate the fact that we should
#define _ not free the regexp when the object is DESTROY`d. That is because we
#define _ have a pointer to the regexp from the OP, and so will be free`d when
#define _ the OP is free`d
#endif

void
DESTROY(re)
    regexp *	re
PPCODE:
{
    if(!(SvFLAGS(SvRV(ST(0))) & SVf_BREAK))
	pregfree(re);
}

regexp *
current(class)
    char *	class
PPCODE:
{
    regexp *re = (curpm) ? curpm->op_pmregexp : NULL;

    ST(0) = sv_newmortal();
    sv_setref_iv(ST(0), class, (IV) re);
    SvFLAGS(SvRV(ST(0))) |= SVf_BREAK;
    XSRETURN(1);  
}

