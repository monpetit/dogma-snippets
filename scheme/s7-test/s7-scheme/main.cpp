#include <iostream>
#include <string>
#include <cstdlib>
#include <cstdio>
#include <cstring>
#include <vector>

#include "s7.h"
#include "mus-config.h"

#if USE_READLINE_LIBRARY
#include <readline/readline.h>
#include <readline/history.h>
#endif

#include <glibmm.h>

using namespace std;
using namespace Glib;


//
// 스킴 종료 함수
//
static s7_pointer our_exit(s7_scheme *sc, s7_pointer args)
{
    /* all added functions have this form, args is a list,
     *    s7_car(args) is the 1st arg, etc
     */
    free(sc);
    exit(1);
    return (s7_nil(sc)); /* never executed, but makes the compiler happier */
}



static int ustr_type_tag = 0;

static s7_pointer make_ustr(s7_scheme *sc, s7_pointer args)
{
    ustring *ustr = new ustring();
    ustr->assign(s7_string(s7_car(args)));
    return (s7_make_object(sc, ustr_type_tag, static_cast<void*>(ustr)));
}


static char* print_ustr(s7_scheme *sc, void* val)
{
    ustring* ustr = static_cast<ustring*>(val);
    size_t length = strlen(ustr->data()) + 1;
    char* result = new char[length];
    strcpy(result, ustr->data());
    return result;
}

static void free_ustr(void* val)
{
    if (val) delete static_cast<ustring*>(val);
}

static s7_pointer is_ustr(s7_scheme *sc, s7_pointer args)
{
    return (s7_make_boolean(sc,
                            s7_is_object(s7_car(args)) &&
                            s7_object_type(s7_car(args)) == ustr_type_tag));
}

bool equal_ustr(void* val1, void* val2)
{
    ustring* a = static_cast<ustring*>(val1);
    ustring* b = static_cast<ustring*>(val2);
#if 0
    std::cout << a->data() << std::endl;
    std::cout << b->data() << std::endl;
    std::cout << a->compare(b->data()) << std::endl;
#endif
    bool ret_value;
    if (a->compare(b->data()) == 0) {
        ret_value = true;
        std::cout << ""; // 같다!" << std::endl;
    }
    else {
        ret_value = false;
        std::cout << ""; // 다르다!" << std::endl;
    }

    return ret_value;
}


static s7_pointer append_ustr(s7_scheme *sc, s7_pointer args)
{
    if (!(s7_is_object(s7_car(args)) && s7_object_type(s7_car(args)) == ustr_type_tag))
        return (s7_wrong_type_arg_error(sc, "ustr-append", 1, s7_car(args), "a ustring"));

    int len = s7_list_length(sc, args);
    if (len != 2)
        return (s7_wrong_number_of_args_error(sc, "ustr-append", args));

    ustring* ustr = static_cast<ustring*>(s7_object_value(s7_car(args)));
    s7_pointer text = s7_cadr(args);

    ustring* out_ustr = new ustring;
    out_ustr->assign(ustr->data());

    if (s7_is_string(text))
        out_ustr->append(s7_string(text));
    else if (s7_is_object(text) && s7_object_type(text) == ustr_type_tag) {
        ustring* src = static_cast<ustring*>(s7_object_value(text));
        out_ustr->append(src->data());
    }
    else {
        delete out_ustr;
        return s7_nil(sc);
    }

    return (s7_make_object(sc, ustr_type_tag, static_cast<void*>(out_ustr)));
    // return(s7_make_string(sc, ustr->data()));
}

static s7_pointer length_ustr(s7_scheme *sc, s7_pointer args)
{
    if (!(s7_is_object(s7_car(args)) && s7_object_type(s7_car(args)) == ustr_type_tag))
        return (s7_wrong_type_arg_error(sc, "ustr-length", 1, s7_car(args), "a ustring"));

    ustring* ustr = static_cast<ustring*>(s7_object_value(s7_car(args)));
    return s7_make_integer(sc, ustr->size());
}

static s7_pointer to_string_ustr(s7_scheme *sc, s7_pointer args)
{
    if (!(s7_is_object(s7_car(args)) && s7_object_type(s7_car(args)) == ustr_type_tag))
        return (s7_wrong_type_arg_error(sc, "ustr->string", 1, s7_car(args), "a ustring"));

    ustring* ustr = static_cast<ustring*>(s7_object_value(s7_car(args)));
    return (s7_make_string(sc, ustr->data()));
}

static s7_pointer substr_ustr(s7_scheme *sc, s7_pointer args)
{
    if (!(s7_is_object(s7_car(args)) && s7_object_type(s7_car(args)) == ustr_type_tag))
        return (s7_wrong_type_arg_error(sc, "ustr-substr", 1, s7_car(args), "a ustring"));

    ustring* ustr = static_cast<ustring*>(s7_object_value(s7_car(args)));
    s7_pointer si = s7_cadr(args);
    s7_pointer sn = s7_caddr(args);

    if (!s7_is_integer(si) || !s7_is_integer(sn))
        return s7_nil(sc);

    size_t i = s7_integer(si);
    size_t n = s7_integer(sn);
    // std::cout << "i = " << i << ", n = " << n << ", ustr size = " << ustr->size() << std::endl;

    ustring* out_ustr = new ustring;

    if (i <= ustr->size()) {
        if (ustr->size() < (i + n))
            n = ustr->size() - i;
        // std::cout << "i = " << i << ", n = " << n << ", ustr size = " << ustr->size() << std::endl;
        out_ustr->assign(ustr->substr(i, n));
    }

    return (s7_make_object(sc, ustr_type_tag, static_cast<void*>(out_ustr)));
}


static s7_pointer find_ustr(s7_scheme *sc, s7_pointer args)
{
    if (!(s7_is_object(s7_car(args)) && s7_object_type(s7_car(args)) == ustr_type_tag))
        return (s7_wrong_type_arg_error(sc, "ustr-find", 1, s7_car(args), "a ustring"));

    ustring* ustr = static_cast<ustring*>(s7_object_value(s7_car(args)));
    s7_pointer text = s7_cadr(args);

    size_t i = 0;
    s7_pointer si = s7_caddr(args);
    if (s7_is_integer(si))
        i = s7_integer(si);

    int result = 0;
    if (s7_is_string(text)) {
        result = ustr->find(s7_string(text), i);
    }
    else if (s7_is_object(text) && s7_object_type(text) == ustr_type_tag) {
        ustring* pattern = static_cast<ustring*>(s7_object_value(text));
        result = ustr->find(pattern->data(), i);
    }
    else {
        return (s7_wrong_type_arg_error(sc, "ustr-find", 2, s7_car(args), "a string or ustring"));
    }

    return s7_make_integer(sc, result);
}


static s7_pointer upper_ustr(s7_scheme *sc, s7_pointer args)
{
    if (!(s7_is_object(s7_car(args)) && s7_object_type(s7_car(args)) == ustr_type_tag))
        return (s7_wrong_type_arg_error(sc, "ustr-upper", 1, s7_car(args), "a ustring"));

#if 0
    int len = s7_list_length(sc, args);
    if (len != 2)
        return (s7_wrong_number_of_args_error(sc, "ustr-upper", args));
#endif

    ustring* ustr = static_cast<ustring*>(s7_object_value(s7_car(args)));

    ustring* out_ustr = new ustring;
    out_ustr->assign(ustr->uppercase());

    return (s7_make_object(sc, ustr_type_tag, static_cast<void*>(out_ustr)));
}


static s7_pointer lower_ustr(s7_scheme *sc, s7_pointer args)
{
    if (!(s7_is_object(s7_car(args)) && s7_object_type(s7_car(args)) == ustr_type_tag))
        return (s7_wrong_type_arg_error(sc, "ustr-upper", 1, s7_car(args), "a ustring"));

#if 0
    int len = s7_list_length(sc, args);
    if (len != 2)
        return (s7_wrong_number_of_args_error(sc, "ustr-upper", args));
#endif

    ustring* ustr = static_cast<ustring*>(s7_object_value(s7_car(args)));

    ustring* out_ustr = new ustring;
    out_ustr->assign(ustr->lowercase());

    return (s7_make_object(sc, ustr_type_tag, static_cast<void*>(out_ustr)));
}


// (ustr-replace ustr i n str)
static s7_pointer replace_ustr(s7_scheme *sc, s7_pointer args)
{
    if (!(s7_is_object(s7_car(args)) && s7_object_type(s7_car(args)) == ustr_type_tag))
        return (s7_wrong_type_arg_error(sc, "ustr-replace", 1, s7_car(args), "a ustring"));

    ustring* ustr = static_cast<ustring*>(s7_object_value(s7_car(args)));
    s7_pointer si = s7_cadr(args);
    s7_pointer sn = s7_caddr(args);
    s7_pointer text = s7_cadddr(args);

    if (!s7_is_integer(si))
        return (s7_wrong_type_arg_error(sc, "ustr-replace", 2, si, "an integer"));
    if (!s7_is_integer(sn))
        return (s7_wrong_type_arg_error(sc, "ustr-replace", 3, sn, "an integer"));
    if (!(s7_is_string(text) || (s7_is_object(text) && (s7_object_type(text)== ustr_type_tag))))
        return (s7_wrong_type_arg_error(sc, "ustr-replace", 4, text, "a ustring or string"));

    ustring* out_ustr = new ustring;
    out_ustr->assign(ustr->data());
    int i = s7_integer(si);
    int n = s7_integer(sn);
    char* text_str;

    if (s7_is_string(text))
        text_str = (char*)s7_string(text);
    else {
        ustring* rep_str = static_cast<ustring*>(s7_object_value(text));
        text_str = (char*)rep_str->data();
    }
    out_ustr->replace(i, n, text_str);

    return (s7_make_object(sc, ustr_type_tag, static_cast<void*>(out_ustr)));
}


// (ustr-insert ustr i str)
static s7_pointer insert_ustr(s7_scheme *sc, s7_pointer args)
{
    if (!(s7_is_object(s7_car(args)) && s7_object_type(s7_car(args)) == ustr_type_tag))
        return (s7_wrong_type_arg_error(sc, "ustr-insert", 1, s7_car(args), "a ustring"));

    ustring* ustr = static_cast<ustring*>(s7_object_value(s7_car(args)));
    s7_pointer si = s7_cadr(args);
    s7_pointer text = s7_caddr(args);

    if (!s7_is_integer(si))
        return (s7_wrong_type_arg_error(sc, "ustr-insert", 2, si, "an integer"));
    if (!(s7_is_string(text) || (s7_is_object(text) && (s7_object_type(text)== ustr_type_tag))))
        return (s7_wrong_type_arg_error(sc, "ustr-insert", 3, text, "a ustring or string"));

    ustring* out_ustr = new ustring;
    out_ustr->assign(ustr->data());
    int i = s7_integer(si);
    char* text_str;

    if ((i < 0) || ((int) ustr->size() < i))
        return (s7_out_of_range_error(sc, "ustr-insert", 2, si, "insert position is out of range"));

    if (s7_is_string(text))
        text_str = (char*)s7_string(text);
    else {
        ustring* rep_str = static_cast<ustring*>(s7_object_value(text));
        text_str = (char*)rep_str->data();
    }
    out_ustr->insert(i, text_str);

    return (s7_make_object(sc, ustr_type_tag, static_cast<void*>(out_ustr)));
}


///////////////// tiny Glib::Regex ////////////////

class ScmRegex
{
public:
    ScmRegex(ustring& pattern_str,
             RegexCompileFlags comp_options = static_cast<RegexCompileFlags>(0),
             RegexMatchFlags match_options = static_cast<RegexMatchFlags>(0))
    {
        regex = Regex::create(pattern_str, comp_options, match_options);
        pattern = pattern_str;
        copts = comp_options;
        mopts = match_options;
    }

    RefPtr<Glib::Regex> regex;
    ustring pattern;
    RegexCompileFlags copts;
    RegexMatchFlags mopts;
};


static int regex_type_tag = 0;

static s7_pointer make_regex(s7_scheme *sc, s7_pointer args)
{
    int len = s7_list_length(sc, args);
    if (len < 1)
        return (s7_wrong_number_of_args_error(sc, "regex-create", args));

    s7_pointer pattern = s7_car(args);
    RegexCompileFlags copts;
    RegexMatchFlags mopts;

    if (!(s7_is_string(pattern) ||
          (s7_is_object(pattern) && (s7_object_type(pattern)== ustr_type_tag))))
        return (s7_wrong_type_arg_error(sc, "regex-create", 1, pattern, "a ustring or string"));

    if (len >= 2) {
        if (!s7_is_integer(s7_cadr(args)))
            return (s7_wrong_type_arg_error(sc, "regex-create", 2, s7_cadr(args), "an integer"));
        copts = static_cast<RegexCompileFlags>(s7_integer(s7_cadr(args)));
    }
    else
        copts = static_cast<RegexCompileFlags>(0);

    if (len == 3) {
        if (!s7_is_integer(s7_caddr(args)))
            return (s7_wrong_type_arg_error(sc, "regex-create", 3, s7_caddr(args), "an integer"));
        mopts = static_cast<RegexMatchFlags>(s7_integer(s7_caddr(args)));
    }
    else
        mopts = static_cast<RegexMatchFlags>(0);

    ustring patt;
    if (s7_is_string(pattern))
        patt.assign(s7_string(pattern));
    else {
        ustring* patt_str = static_cast<ustring*>(s7_object_value(pattern));
        patt.assign(patt_str->data());
    }

    ScmRegex* scm_regex = new ScmRegex(patt, copts, mopts);
    return (s7_make_object(sc, regex_type_tag, static_cast<void*>(scm_regex)));
}


static char* print_regex(s7_scheme *sc, void* val)
{
    ScmRegex* scm_regex = static_cast<ScmRegex*>(val);

    ustring format_str = ustring::compose("#<scm-regex: pattern=\"%1\", compile-options=%2, match-options=%3>",
                                          scm_regex->pattern,
                                          scm_regex->copts,
                                          scm_regex->mopts);
    char* result = new char[format_str.bytes()+1];
    strcpy(result, format_str.data());
    return result;
}

static void free_regex(void* val)
{
    if (val) delete static_cast<ScmRegex*>(val);
}


static s7_pointer is_regex(s7_scheme *sc, s7_pointer args)
{
    return (s7_make_boolean(sc,
                            s7_is_object(s7_car(args)) &&
                            s7_object_type(s7_car(args)) == regex_type_tag));
}


static s7_pointer split_simple_regex(s7_scheme *sc, s7_pointer args)
{
    int len = s7_list_length(sc, args);
    if (len < 2)
        return (s7_wrong_number_of_args_error(sc, "regex-split-simple", args));

    s7_pointer pattern = s7_car(args);
    s7_pointer text = s7_cadr(args);

    RegexCompileFlags copts;
    RegexMatchFlags mopts;

    if (!(s7_is_string(pattern) ||
          (s7_is_object(pattern) && (s7_object_type(pattern)== ustr_type_tag))))
        return (s7_wrong_type_arg_error(sc, "regex-split-simple", 1, pattern, "a ustring or string"));

    if (!(s7_is_string(text) ||
          (s7_is_object(text) && (s7_object_type(text)== ustr_type_tag))))
        return (s7_wrong_type_arg_error(sc, "regex-split-simple", 2, text, "a ustring or string"));

    if (len >= 3) {
        if (!s7_is_integer(s7_caddr(args)))
            return (s7_wrong_type_arg_error(sc, "regex-split-simple", 3, s7_caddr(args), "an integer"));
        copts = static_cast<RegexCompileFlags>(s7_integer(s7_caddr(args)));
    }
    else
        copts = static_cast<RegexCompileFlags>(0);

    if (len == 4) {
        if (!s7_is_integer(s7_cadddr(args)))
            return (s7_wrong_type_arg_error(sc, "regex-split-simple", 4, s7_cadddr(args), "an integer"));
        mopts = static_cast<RegexMatchFlags>(s7_integer(s7_cadddr(args)));
    }
    else
        mopts = static_cast<RegexMatchFlags>(0);

    ustring patt;
    if (s7_is_string(pattern))
        patt.assign(s7_string(pattern));
    else {
        ustring* patt_str = static_cast<ustring*>(s7_object_value(pattern));
        patt.assign(patt_str->data());
    }

    ustring txt;
    if (s7_is_string(text))
        txt.assign(s7_string(text));
    else {
        ustring* patt_str = static_cast<ustring*>(s7_object_value(text));
        txt.assign(patt_str->data());
    }

    std::vector<ustring> result = Regex::split_simple(patt, txt, copts, mopts);

    len = result.size();
    s7_pointer vec = s7_make_vector(sc, len);

    if (len > 0) {
        for (int i = 0; i < len; i++) {
            ustring *ustr = new ustring();
            ustr->assign(result[i]);
            s7_vector_set(sc, vec, i, s7_make_object(sc, ustr_type_tag, static_cast<void*>(ustr)));
        }
    }

    return (s7_vector_to_list(sc, vec));
}


static s7_pointer match_simple_regex(s7_scheme *sc, s7_pointer args)
{
    int len = s7_list_length(sc, args);
    if (len < 2)
        return (s7_wrong_number_of_args_error(sc, "regex-match-simple", args));

    s7_pointer pattern = s7_car(args);
    s7_pointer text = s7_cadr(args);

    RegexCompileFlags copts;
    RegexMatchFlags mopts;

    if (!(s7_is_string(pattern) ||
          (s7_is_object(pattern) && (s7_object_type(pattern)== ustr_type_tag))))
        return (s7_wrong_type_arg_error(sc, "regex-match-simple", 1, pattern, "a ustring or string"));

    if (!(s7_is_string(text) ||
          (s7_is_object(text) && (s7_object_type(text)== ustr_type_tag))))
        return (s7_wrong_type_arg_error(sc, "regex-match-simple", 2, text, "a ustring or string"));

    if (len >= 3) {
        if (!s7_is_integer(s7_caddr(args)))
            return (s7_wrong_type_arg_error(sc, "regex-match-simple", 3, s7_caddr(args), "an integer"));
        copts = static_cast<RegexCompileFlags>(s7_integer(s7_caddr(args)));
    }
    else
        copts = static_cast<RegexCompileFlags>(0);

    if (len == 4) {
        if (!s7_is_integer(s7_cadddr(args)))
            return (s7_wrong_type_arg_error(sc, "regex-match-simple", 4, s7_cadddr(args), "an integer"));
        mopts = static_cast<RegexMatchFlags>(s7_integer(s7_cadddr(args)));
    }
    else
        mopts = static_cast<RegexMatchFlags>(0);

    ustring patt;
    if (s7_is_string(pattern))
        patt.assign(s7_string(pattern));
    else {
        ustring* patt_str = static_cast<ustring*>(s7_object_value(pattern));
        patt.assign(patt_str->data());
    }

    ustring txt;
    if (s7_is_string(text))
        txt.assign(s7_string(text));
    else {
        ustring* patt_str = static_cast<ustring*>(s7_object_value(text));
        txt.assign(patt_str->data());
    }

    bool match = Regex::match_simple(patt, txt, copts, mopts);

    return s7_make_boolean(sc, match);
}



static s7_pointer match_regex(s7_scheme *sc, s7_pointer args)
{
    int len = s7_list_length(sc, args);
    if (len < 2)
        return (s7_wrong_number_of_args_error(sc, "regex-match", args));

    s7_pointer regex = s7_car(args);
    s7_pointer text = s7_cadr(args);

    int start = 0;
    RegexMatchFlags mopts = static_cast<RegexMatchFlags>(0);

    if (!((s7_is_object(regex) &&
           (s7_object_type(regex)== regex_type_tag))))
        return (s7_wrong_type_arg_error(sc, "regex-match", 1, regex, "a regex"));

    if (!(s7_is_string(text) ||
          (s7_is_object(text) && (s7_object_type(text)== ustr_type_tag))))
        return (s7_wrong_type_arg_error(sc, "regex-match", 2, text, "a ustring or string"));

    if (len >= 3) {
        if (!s7_is_integer(s7_caddr(args)))
            return (s7_wrong_type_arg_error(sc, "regex-match", 3, s7_caddr(args), "an integer"));
        start = s7_integer(s7_caddr(args));
    }

    if (len == 4) {
        if (!s7_is_integer(s7_cadddr(args)))
            return (s7_wrong_type_arg_error(sc, "regex-match", 4, s7_cadddr(args), "an integer"));
        mopts = static_cast<RegexMatchFlags>(s7_integer(s7_cadddr(args)));
    }

    ustring txt;
    if (s7_is_string(text))
        txt.assign(s7_string(text));
    else {
        ustring* patt_str = static_cast<ustring*>(s7_object_value(text));
        txt.assign(patt_str->data());
    }

    ScmRegex* scm_regex = static_cast<ScmRegex*>(s7_object_value(regex));
    bool match = scm_regex->regex->match(txt, start, mopts);

    return s7_make_boolean(sc, match);
}






void register_globals(s7_scheme* sc)
{
    s7_define_function(sc, "exit", our_exit, 0, 0, false, "(exit) exits the program");

    // Glib::ustring
    ustr_type_tag = s7_new_type("ustr", print_ustr, free_ustr, equal_ustr, NULL, NULL, NULL);
    s7_define_function(sc, "ustr", make_ustr, 1, 0, false, "(ustr text) makes a new ustring");
    s7_define_function(sc, "ustr?", is_ustr, 1, 0, false, "(ustr? text) is this ustring?");
    s7_define_function(sc, "ustr-append", append_ustr, 2, 0, false, "(ustr-append ustring ustring/text) append text to ustring");
    s7_define_function(sc, "ustr-length", length_ustr, 1, 0, false, "(ustr-length ustring) get length of ustring");
    s7_define_function(sc, "ustr->string", to_string_ustr, 1, 0, false, "(ustr->string ustring) convert ustring to string");
    s7_define_function(sc, "ustr-substr", substr_ustr, 3, 0, false, "(ustr-substr ustring start len) substring of ustring");
    s7_define_function(sc, "ustr-find", find_ustr, 2, 1, false, "(ustr-find ustring text start) find text in ustring");
    s7_define_function(sc, "ustr-upper", upper_ustr, 1, 0, false, "(ustr-upper ustring) convert ustring to uppercase");
    s7_define_function(sc, "ustr-lower", lower_ustr, 1, 0, false, "(ustr-lower ustring) convert ustring to lowercase");
    s7_define_function(sc, "ustr-replace", replace_ustr, 4, 0, false, "(ustr-replace ustring i n text) replace ustring with text");
    s7_define_function(sc, "ustr-insert", insert_ustr, 3, 0, false, "(ustr-insert ustring i text) insert ustring with text");

    regex_type_tag = s7_new_type("scm-regex", print_regex, free_regex, NULL, NULL, NULL, NULL);
    s7_define_function(sc, "regex-create", make_regex, 1, 2, false, "(regex-create pattern compile_options match_options) makes a regex object");
    s7_define_function(sc, "regex?", is_regex, 1, 0, false, "(regex? re) is this regex object?");
    s7_define_function(sc, "regex-split-simple", split_simple_regex, 2, 2, false, "(regex-split-simple pattern text compile_options match_options) split text with the pattern");
    s7_define_function(sc, "regex-match-simple", match_simple_regex, 2, 2, false, "(regex-match-simple pattern text compile_options match_options) judge match pattern in text");
    s7_define_function(sc, "regex-match", match_regex, 2, 2, false, "(regex-match regex text start match_options) judge match pattern in text");

    // regex match flags...
    s7_define_constant(sc, "REGEX_CASELESS", s7_make_integer(sc, REGEX_CASELESS));
    s7_define_constant(sc, "REGEX_MULTILINE", s7_make_integer(sc, REGEX_MULTILINE));
    s7_define_constant(sc, "REGEX_DOTALL", s7_make_integer(sc, REGEX_DOTALL));
    s7_define_constant(sc, "REGEX_EXTENDED", s7_make_integer(sc, REGEX_EXTENDED));
    s7_define_constant(sc, "REGEX_ANCHORED", s7_make_integer(sc, REGEX_ANCHORED));
    s7_define_constant(sc, "REGEX_DOLLAR_ENDONLY", s7_make_integer(sc, REGEX_DOLLAR_ENDONLY));
    s7_define_constant(sc, "REGEX_UNGREEDY", s7_make_integer(sc, REGEX_UNGREEDY));
    s7_define_constant(sc, "REGEX_RAW", s7_make_integer(sc, REGEX_RAW));
    s7_define_constant(sc, "REGEX_NO_AUTO_CAPTURE", s7_make_integer(sc, REGEX_NO_AUTO_CAPTURE));
    s7_define_constant(sc, "REGEX_OPTIMIZE", s7_make_integer(sc, REGEX_OPTIMIZE));
    s7_define_constant(sc, "REGEX_DUPNAMES", s7_make_integer(sc, REGEX_DUPNAMES));
    s7_define_constant(sc, "REGEX_NEWLINE_CR", s7_make_integer(sc, REGEX_NEWLINE_CR));
    s7_define_constant(sc, "REGEX_NEWLINE_LF", s7_make_integer(sc, REGEX_NEWLINE_LF));
    s7_define_constant(sc, "REGEX_NEWLINE_CRLF", s7_make_integer(sc, REGEX_NEWLINE_CRLF));

    s7_define_constant(sc, "REGEX_MATCH_ANCHORED", s7_make_integer(sc, REGEX_MATCH_ANCHORED));
    s7_define_constant(sc, "REGEX_MATCH_NOTBOL", s7_make_integer(sc, REGEX_MATCH_NOTBOL));
    s7_define_constant(sc, "REGEX_MATCH_NOTEOL", s7_make_integer(sc, REGEX_MATCH_NOTEOL));
    s7_define_constant(sc, "REGEX_MATCH_NOTEMPTY", s7_make_integer(sc, REGEX_MATCH_NOTEMPTY));
    s7_define_constant(sc, "REGEX_MATCH_PARTIAL", s7_make_integer(sc, REGEX_MATCH_PARTIAL));
    s7_define_constant(sc, "REGEX_MATCH_NEWLINE_CR", s7_make_integer(sc, REGEX_MATCH_NEWLINE_CR));
    s7_define_constant(sc, "REGEX_MATCH_NEWLINE_LF", s7_make_integer(sc, REGEX_MATCH_NEWLINE_LF));
    s7_define_constant(sc, "REGEX_MATCH_NEWLINE_CRLF", s7_make_integer(sc, REGEX_MATCH_NEWLINE_CRLF));
    s7_define_constant(sc, "REGEX_MATCH_NEWLINE_ANY", s7_make_integer(sc, REGEX_MATCH_NEWLINE_ANY));

}


void register_user_code(s7_scheme* sc)
{
    std::string code = \
            "(define (prt . args) (for-each (lambda (x) (display x) (display #\\space)) args) (newline))"
            "(define (prtln . args) (for-each (lambda (x) (display x) (newline)) args))"
            "(define (hash-table-keys ht) (map car ht))"
            "(define (hash-table-values ht) (map cdr ht))"



            "(define (ustr-car us)"
            "  (if (not (ustr? us))"
            "      (error 'wrong-type-arg-error \"ustr-car argument must be real: ~S\" ustr)"
            "      (if (<= (ustr-length us) 0)"
            "          (error 'bad-length \"ustr-car argument length must be positive\")"
            "          (ustr-substr us 0 1))))"

            "(define (ustr-cdr us)"
            "  (if (not (ustr? us))"
            "      (error 'wrong-type-arg-error \"ustr-car argument must be real: ~S\" ustr)"
            "      (if (<= (ustr-length us) 0)"
            "          (error 'bad-length \"ustr-car argument length must be positive\")"
            "          (ustr-substr us 1 (- (ustr-length us) 1)))))"

            "(define (ustr->number us) (string->number (ustr->string us)))"
            "(define (number->ustr num) (ustr (number->string num)))"
            "(define (ustr->list us)"
            "  (if (= (ustr-length us) 0)"
            "      '()"
            "      (cons (ustr-car us) (ustr->list (ustr-cdr us)))))"

            "(define (do-times count proc)"
            "  (if (<= count 0)"
            "      '()"
            "      (begin"
            "        (proc)"
            "        (do-times (- count 1) proc))))"

            ;
    s7_eval_c_string(sc, code.data());
}


//
// 메인 함수
//
int main(int argc, char** argv)
{
    INIT_LOCALE;

    s7_scheme* s7;
    s7 = s7_init();
    register_globals(s7);
    register_user_code(s7);


#if USE_READLINE_LIBRARY
    char* input;
    char prompt[] = "\ns7(user)> \0x00";

    s7_pointer val;
    for(;;) {
        // inputing...
        input = readline(prompt);
        // eof
        if (!input) break;
        // path autocompletion when tabulation hit
        rl_bind_key('\t', rl_complete);
        // adding the previous input into history
        add_history(input);

        val = s7_eval_c_string(s7, input);
        std::cout << s7_object_to_c_string(s7, val);
    }
#else
    std::string buffer;

    s7_pointer val;
    while (std::cin) {
        std::cout << std::endl << "s7> ";
        getline(std::cin, buffer);
        val = s7_eval_c_string(s7, buffer.data());
        std::cout << s7_object_to_c_string(s7, val);
    }
#endif

    free(s7);
    return 0;
}

