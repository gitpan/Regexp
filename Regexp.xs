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

static int
not_here(s)
	char *	s;
{
    croak("%s not implemented on this architecture", s);
    return -1;
}

static int
constant(name, arg)
	char *	name;
	int	arg;
{
    errno = 0;
    switch (*name) {
    case 'E':
	if (strEQ(name, "EVAL"))
#ifdef PMf_EVAL
	    return PMf_EVAL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "EXTENDED"))
#ifdef PMf_EXTENDED
	    return PMf_EXTENDED;
#else
	    goto not_there;
#endif
	    break;
    case 'F':
	if (strEQ(name, "FOLD"))
#ifdef PMf_FOLD
		return PMf_FOLD;
#else
	    goto not_there;
#endif
	    break;
    case 'G':
	if (strEQ(name, "GLOBAL"))
#ifdef PMf_GLOBAL
	    return PMf_GLOBAL;
#else
	    goto not_there;
#endif
	    break;
    case 'K':
	if (strEQ(name, "KEEP"))
#ifdef PMf_KEEP
	    return PMf_KEEP;
#else
	    goto not_there;
#endif
	    break;
    case 'M':
	if (strEQ(name, "MULTILINE"))
#ifdef PMf_MULTILINE
	    return PMf_MULTILINE;
#else
	    goto not_there;
#endif
	    break;
    case 'S':
	if (strEQ(name, "SINGLELINE"))
#ifdef PMf_SINGLELINE
	    return PMf_SINGLELINE;
#else
	    goto not_there;
#endif
	    break;
    default:
	goto not_there;
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

#define DEFAULT_SCALAR GvSV(defgv)

#define Regexp_nparens(rx) ((rx)->nparens)
#define Regexp_lastparen(rx) ((rx)->lastparen)
#define Regexp_minlength(rx) ((rx)->minlen)

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

int
constant(name,arg)
	char *	name
	int	arg

void
pattern(re)
	regexp *	re
PPCODE:
{
    ST(0) = sv_newmortal();
    sv_setpvn(ST(0), re->precomp, re->prelen);
    XSRETURN(1);
}

void
parentheses(re)
	regexp *	re
PPCODE:
{
    if (GIMME & G_ARRAY) {
	int i;
	for (i=1; i <= re->nparens; i++) {
	    SV *sv = sv_newmortal();
	    sv_setpvn(sv,re->startp[i],re->endp[i] - re->startp[i]);
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

void
lastmatch(re)
	regexp *	re
PPCODE:
{
    ST(0) = sv_newmortal();
    sv_setpvn(ST(0),re->startp[0],re->endp[0] - re->startp[0]);
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

regexp *
new(class,pattern,pmflags = 0)
	char *	class
	SV   *	pattern
	U16	pmflags
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
	SV *		string
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

