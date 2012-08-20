#include <libguile.h>

#include <iostream>
#include <cstdlib>
#include <vector>

#include <glibmm.h>

using namespace Glib;

struct ScmRegex
{
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

static scm_t_bits scm_regex_tag;


size_t
free_regex(SCM regex_smob)
{
    ScmRegex* regex = (ScmRegex*) SCM_SMOB_DATA(regex_smob);
    delete regex;
    return 0;
}

static int
print_regex(SCM regex_smob, SCM port, scm_print_state *pstate)
{
    ScmRegex* regex = (ScmRegex*) SCM_SMOB_DATA(regex_smob);

    ustring format_str = \
            ustring::compose("#<regex: pattern=\"%1\", compile-options=%2, match-options=%3>",
                             regex->pattern,
                             regex->copts,
                             regex->mopts);

    scm_puts (format_str.data(), port);

    /* non-zero means success */
    return 1;
}


static SCM
equal_regex(SCM regex_smob1, SCM regex_smob2)
{
    ScmRegex* regex1 = (ScmRegex*) SCM_SMOB_DATA(regex_smob1);
    ScmRegex* regex2 = (ScmRegex*) SCM_SMOB_DATA(regex_smob2);

    return scm_from_bool(((regex1->pattern.compare(regex2->pattern) == 0) &&
                          (regex1->copts == regex2->copts) &&
                          (regex1->mopts == regex2->mopts)));
}


void
init_regex_type(void)
{
    scm_regex_tag = scm_make_smob_type("regex", sizeof(ScmRegex));
    // scm_set_smob_mark (scm_regex_tag, mark_regex);
    scm_set_smob_free (scm_regex_tag, free_regex);
    scm_set_smob_print (scm_regex_tag, print_regex);
    scm_set_smob_equalp(scm_regex_tag, equal_regex);
}


SCM
make_regex(SCM pattern_string, SCM compile_flags, SCM match_flags)
{
    SCM smob;

    ustring pattern = scm_to_locale_string(pattern_string);
    RegexCompileFlags copts = static_cast<RegexCompileFlags>(0);
    RegexMatchFlags mopts = static_cast<RegexMatchFlags>(0);

    if (!SCM_UNBNDP(compile_flags))
        copts = static_cast<RegexCompileFlags>(scm_to_int(compile_flags));
    if (!SCM_UNBNDP(match_flags))
        mopts = static_cast<RegexMatchFlags>(scm_to_int(match_flags));

    /* Step 1: Allocate the memory block. */
    ScmRegex* regex = new ScmRegex(pattern, copts, mopts);

    /* Step 2: Initialize it with straight code. */

    /* Step 3: Create the smob. */
    SCM_NEWSMOB(smob, scm_regex_tag, regex);

    /* Step 4: Finish the initialization.*/

    return smob;
}


static SCM regex_match_simple(SCM pat, SCM str, SCM cflags, SCM mflags)
{
    ustring pattern = scm_to_locale_string(pat);
    ustring ustr = scm_to_locale_string(str);
    int copts = 0;
    int mopts = 0;

    if (!SCM_UNBNDP(cflags))
        copts = scm_to_int(cflags);
    if (!SCM_UNBNDP(mflags))
        mopts = scm_to_int(mflags);

    return scm_from_bool(Regex::match_simple(pattern,
                                             ustr,
                                             static_cast<RegexCompileFlags>(copts),
                                             static_cast<RegexMatchFlags>(mopts)));
}


static SCM regex_split_simple(SCM pat, SCM str, SCM cflags, SCM mflags)
{
    ustring pattern = scm_to_locale_string(pat);
    ustring ustr = scm_to_locale_string(str);
    int copts = 0;
    int mopts = 0;

    if (!SCM_UNBNDP(cflags))
        copts = scm_to_int(cflags);
    if (!SCM_UNBNDP(mflags))
        mopts = scm_to_int(mflags);

    std::vector<ustring> result = \
            Regex::split_simple(pattern,
                                ustr,
                                static_cast<RegexCompileFlags>(copts),
                                static_cast<RegexMatchFlags>(mopts));

    SCM vec = scm_c_make_vector(result.size(), SCM_UNDEFINED);
    for (int i = 0; i < SCM_SIMPLE_VECTOR_LENGTH(vec); i++)
        SCM_SIMPLE_VECTOR_SET(vec, i, scm_from_locale_string(result[i].data()));

    return scm_vector_to_list(vec);
}


static SCM regex_match(SCM regex_smob, SCM str, SCM start_position, SCM mflags)
{
    scm_assert_smob_type(scm_regex_tag, regex_smob);

    ScmRegex* regex = (ScmRegex*) SCM_SMOB_DATA(regex_smob);
    ustring ustr = scm_to_locale_string(str);
    int start_pos = 0;
    RegexMatchFlags mopts = static_cast<RegexMatchFlags>(0);

    if (!SCM_UNBNDP(start_position))
        start_pos = scm_to_int(start_position);
    if (!SCM_UNBNDP(mflags))
        mopts = static_cast<RegexMatchFlags>(scm_to_int(mflags));

    MatchInfo minfo;
    bool match = regex->regex->match(ustr, start_pos, minfo, mopts);
    if (!match)
        return SCM_BOOL_F;

    std::vector<ustring> result = minfo.fetch_all();

    SCM vec = scm_c_make_vector(result.size(), SCM_UNDEFINED);
    for (int i = 0; i < SCM_SIMPLE_VECTOR_LENGTH(vec); i++)
        SCM_SIMPLE_VECTOR_SET(vec, i, scm_from_locale_string(result[i].data()));

    return scm_vector_to_list(vec);
}


static SCM regex_match_all(SCM regex_smob, SCM str, SCM start_position, SCM mflags)
{
    scm_assert_smob_type(scm_regex_tag, regex_smob);

    ScmRegex* regex = (ScmRegex*) SCM_SMOB_DATA(regex_smob);
    ustring ustr = scm_to_locale_string(str);
    int start_pos = 0;
    RegexMatchFlags mopts = static_cast<RegexMatchFlags>(0);

    if (!SCM_UNBNDP(start_position))
        start_pos = scm_to_int(start_position);
    if (!SCM_UNBNDP(mflags))
        mopts = static_cast<RegexMatchFlags>(scm_to_int(mflags));

    MatchInfo minfo;
    bool match = regex->regex->match_all(ustr, start_pos, minfo, mopts);
    if (!match)
        return SCM_BOOL_F;

    std::vector<ustring> result = minfo.fetch_all();

    SCM vec = scm_c_make_vector(result.size(), SCM_UNDEFINED);
    for (int i = 0; i < SCM_SIMPLE_VECTOR_LENGTH(vec); i++)
        SCM_SIMPLE_VECTOR_SET(vec, i, scm_from_locale_string(result[i].data()));

    return scm_vector_to_list(vec);
}


static SCM regex_replace(SCM regex_smob, SCM str, SCM replacement, SCM start_position, SCM mflags)
{
    scm_assert_smob_type(scm_regex_tag, regex_smob);

    ScmRegex* regex = (ScmRegex*) SCM_SMOB_DATA(regex_smob);
    ustring ustr = scm_to_locale_string(str);
    ustring repl = scm_to_locale_string(replacement);
    int start_pos = 0;
    RegexMatchFlags mopts = static_cast<RegexMatchFlags>(0);

    if (!SCM_UNBNDP(start_position))
        start_pos = scm_to_int(start_position);
    if (!SCM_UNBNDP(mflags))
        mopts = static_cast<RegexMatchFlags>(scm_to_int(mflags));

    ustring outstr = regex->regex->replace(ustr, start_pos, repl, mopts);

    return scm_from_locale_string(outstr.data());
}


void register_globlas(void)
{
    scm_c_define("REGEX_CASELESS", scm_from_int(REGEX_CASELESS));
    scm_c_define("REGEX_MULTILINE", scm_from_int(REGEX_MULTILINE));
    scm_c_define("REGEX_DOTALL", scm_from_int(REGEX_DOTALL));
    scm_c_define("REGEX_EXTENDED", scm_from_int(REGEX_EXTENDED));
    scm_c_define("REGEX_ANCHORED", scm_from_int(REGEX_ANCHORED));
    scm_c_define("REGEX_DOLLAR_ENDONLY", scm_from_int(REGEX_DOLLAR_ENDONLY));
    scm_c_define("REGEX_UNGREEDY", scm_from_int(REGEX_UNGREEDY));
    scm_c_define("REGEX_RAW", scm_from_int(REGEX_RAW));
    scm_c_define("REGEX_NO_AUTO_CAPTURE", scm_from_int(REGEX_NO_AUTO_CAPTURE));
    scm_c_define("REGEX_OPTIMIZE", scm_from_int(REGEX_OPTIMIZE));
    scm_c_define("REGEX_DUPNAMES", scm_from_int(REGEX_DUPNAMES));
    scm_c_define("REGEX_NEWLINE_CR", scm_from_int(REGEX_NEWLINE_CR));
    scm_c_define("REGEX_NEWLINE_LF", scm_from_int(REGEX_NEWLINE_LF));
    scm_c_define("REGEX_NEWLINE_CRLF", scm_from_int(REGEX_NEWLINE_CRLF));

    scm_c_define("REGEX_MATCH_ANCHORED", scm_from_int(REGEX_MATCH_ANCHORED));
    scm_c_define("REGEX_MATCH_NOTBOL", scm_from_int(REGEX_MATCH_NOTBOL));
    scm_c_define("REGEX_MATCH_NOTEOL", scm_from_int(REGEX_MATCH_NOTEOL));
    scm_c_define("REGEX_MATCH_NOTEMPTY", scm_from_int(REGEX_MATCH_NOTEMPTY));
    scm_c_define("REGEX_MATCH_PARTIAL", scm_from_int(REGEX_MATCH_PARTIAL));
    scm_c_define("REGEX_MATCH_NEWLINE_CR", scm_from_int(REGEX_MATCH_NEWLINE_CR));
    scm_c_define("REGEX_MATCH_NEWLINE_LF", scm_from_int(REGEX_MATCH_NEWLINE_LF));
    scm_c_define("REGEX_MATCH_NEWLINE_CRLF", scm_from_int(REGEX_MATCH_NEWLINE_CRLF));
    scm_c_define("REGEX_MATCH_NEWLINE_ANY", scm_from_int(REGEX_MATCH_NEWLINE_ANY));

}


static void inner_main (void* data, int argc, char** argv)
{
    register_globlas();
    scm_c_define_gsubr("regex-match-simple", 2, 2, 0, (void*)regex_match_simple);
    scm_c_define_gsubr("regex-split-simple", 2, 2, 0, (void*)regex_split_simple);

    init_regex_type();
    scm_c_define_gsubr("regex-create", 1, 2, 0, (void*)make_regex);
    scm_c_define_gsubr("regex-match", 2, 2, 0, (void*)regex_match);
    scm_c_define_gsubr("regex-match-all", 2, 2, 0, (void*)regex_match_all);
    scm_c_define_gsubr("regex-replace", 3, 2, 0, (void*)regex_replace);


#if 0
    scm_c_eval_string("(setlocale LC_ALL \"\")");
    scm_c_eval_string("(load \"/home/monpetit/.guile\")");
    scm_c_eval_string("(for-each prt '(1 2 3 4 5 가나다 원영식))");
    scm_c_eval_string("(prt (string-length \"블라디미르\"))");

    SCM value = scm_call_0 (scm_variable_ref(scm_c_lookup("my-hostname")));
    scm_call_1(scm_variable_ref(scm_c_lookup("prt")), value);

    char* host_name = scm_to_locale_string(value);
    std::cout << "호스트 이름은 = " << host_name << std::endl;
#endif


    scm_shell(argc, argv);
}


int main(int argc, char** argv)
{
    std::locale::global(std::locale(""));
    scm_boot_guile(argc, argv, inner_main, 0);
    return 0; /* never reached */
}
