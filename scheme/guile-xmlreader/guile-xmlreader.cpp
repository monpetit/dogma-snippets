#include <libguile.h>

#include <iostream>
#include <cstdlib>
#include <vector>

#include <glibmm.h>
#include <libxml++/libxml++.h>

using namespace Glib;
using namespace xmlpp;


static scm_t_bits scm_textreader_tag;


size_t
free_textreader(SCM reader_smob)
{
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(reader_smob);
    delete reader;
    return 0;
}


static int
print_textreader(SCM reader_smob, SCM port, scm_print_state *pstate)
{
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(reader_smob);

    ustring format_str = \
            ustring::compose("#<text-reader: 0x\"%1\">",
                             reader);

    scm_puts (format_str.data(), port);

    /* non-zero means success */
    return 1;
}


static SCM
equal_textreader(SCM reader_smob1, SCM reader_smob2)
{
    scm_assert_smob_type(scm_textreader_tag, reader_smob1);
    scm_assert_smob_type(scm_textreader_tag, reader_smob2);

    TextReader* reader1 = (TextReader*) SCM_SMOB_DATA(reader_smob1);
    TextReader* reader2 = (TextReader*) SCM_SMOB_DATA(reader_smob2);

    return scm_from_bool(reader1 == reader2);
}


void
init_textreader_type(void)
{
    scm_textreader_tag = scm_make_smob_type("textreader", sizeof(TextReader));
    // scm_set_smob_mark (scm_regex_tag, mark_regex);
    scm_set_smob_free (scm_textreader_tag, free_textreader);
    scm_set_smob_print (scm_textreader_tag, print_textreader);
    scm_set_smob_equalp(scm_textreader_tag, equal_textreader);
}


void
register_textreader_constants(void)
{
    scm_c_define("xmlNodeType.Attribute", scm_from_int(TextReader::Attribute));
    scm_c_define("xmlNodeType.CDATA", scm_from_int(TextReader::CDATA));
    scm_c_define("xmlNodeType.Comment", scm_from_int(TextReader::Comment));
    scm_c_define("xmlNodeType.Document", scm_from_int(TextReader::Document));
    scm_c_define("xmlNodeType.DocumentFragment", scm_from_int(TextReader::DocumentFragment));
    scm_c_define("xmlNodeType.DocumentType", scm_from_int(TextReader::DocumentType));
    scm_c_define("xmlNodeType.Element", scm_from_int(TextReader::Element));
    scm_c_define("xmlNodeType.EndElement", scm_from_int(TextReader::EndElement));
    scm_c_define("xmlNodeType.EndEntity", scm_from_int(TextReader::EndEntity));
    scm_c_define("xmlNodeType.Entity", scm_from_int(TextReader::Entity));
    scm_c_define("xmlNodeType.EntityReference", scm_from_int(TextReader::EntityReference));
    scm_c_define("xmlNodeType.None", scm_from_int(TextReader::None));
    scm_c_define("xmlNodeType.Notation", scm_from_int(TextReader::Notation));
    scm_c_define("xmlNodeType.ProcessingInstruction", scm_from_int(TextReader::ProcessingInstruction));
    scm_c_define("xmlNodeType.SignificantWhitespace", scm_from_int(TextReader::SignificantWhitespace));
    scm_c_define("xmlNodeType.Text", scm_from_int(TextReader::Text));
    scm_c_define("xmlNodeType.Whitespace", scm_from_int(TextReader::Whitespace));
    scm_c_define("xmlNodeType.XmlDeclaration", scm_from_int(TextReader::XmlDeclaration));
    scm_c_define("xmlReadState.Closed", scm_from_int(TextReader::Closed));
    scm_c_define("xmlReadState.EndOfFile", scm_from_int(TextReader::EndOfFile));
    scm_c_define("xmlReadState.Error", scm_from_int(TextReader::Error));
    scm_c_define("xmlReadState.Initial", scm_from_int(TextReader::Initial));
    scm_c_define("xmlReadState.Interactive", scm_from_int(TextReader::Interactive));
    scm_c_define("xmlReadState.Reading", scm_from_int(TextReader::Reading));
    scm_c_define("ParserProperties.LoadDtd", scm_from_int(TextReader::LoadDtd));
    scm_c_define("ParserProperties.DefaultAttrs", scm_from_int(TextReader::DefaultAttrs));
    scm_c_define("ParserProperties.Validate", scm_from_int(TextReader::Validate));
    scm_c_define("ParserProperties.SubstEntities", scm_from_int(TextReader::SubstEntities));
}



SCM
make_reader_with_file(SCM filename)
{
    SCM smob;

    /* Step 1: Allocate the memory block. */
    TextReader* reader = new TextReader(scm_to_locale_string(filename));

    /* Step 2: Initialize it with straight code. */

    /* Step 3: Create the smob. */
    SCM_NEWSMOB(smob, scm_textreader_tag, reader);

    /* Step 4: Finish the initialization.*/
    return smob;
}


SCM
make_reader_with_string(SCM text)
{
    SCM smob;
    SCM bv = scm_string_to_utf8(text);
    size_t len = SCM_BYTEVECTOR_LENGTH(bv);
    const unsigned char* locale_text = (const unsigned char*) scm_to_utf8_string(text);

    std::cout << "xml text = " << locale_text << std::endl;

    /* Step 1: Allocate the memory block. */

    TextReader* reader = new TextReader(locale_text, len);

    /* Step 2: Initialize it with straight code. */

    /* Step 3: Create the smob. */
    SCM_NEWSMOB(smob, scm_textreader_tag, reader);

    /* Step 4: Finish the initialization.*/
    return smob;
}


SCM
reader_read(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_bool(reader->read());
}

SCM
reader_read_inner_xml(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_locale_string(reader->read_inner_xml().data());
}

SCM
reader_read_outer_xml(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_locale_string(reader->read_outer_xml().data());
}

SCM
reader_read_string(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_locale_string(reader->read_string().data());
}

SCM
reader_read_attribute_value(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_bool(reader->read_attribute_value());
}

SCM
reader_get_attribute_count(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_int(reader->get_attribute_count());
}

SCM
reader_get_base_uri(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_locale_string(reader->get_base_uri().data());
}

SCM
reader_get_depth(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_int(reader->get_depth());
}

SCM
reader_has_attributes(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_bool(reader->has_attributes());
}

SCM
reader_has_value(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_bool(reader->has_value());
}

SCM
reader_is_default(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_bool(reader->is_default());
}

SCM
reader_is_empty_element(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_bool(reader->is_empty_element());
}

SCM
reader_get_local_name(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_locale_string(reader->get_local_name().data());
}

SCM
reader_get_name(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_locale_string(reader->get_name().data());
}

SCM
reader_get_namespace_uri(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_locale_string(reader->get_namespace_uri().data());
}


SCM
reader_get_node_type(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_int((int)reader->get_node_type());
}

SCM
reader_get_prefix(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_locale_string(reader->get_prefix().data());
}

SCM
reader_get_quote_char(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_char(reader->get_quote_char());
}

SCM
reader_get_value(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_locale_string(reader->get_value().data());
}

SCM
reader_get_xml_lang(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_locale_string(reader->get_xml_lang().data());
}

SCM
reader_get_read_state(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_int((int)reader->get_read_state());
}

SCM
reader_close(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    reader->close();
    return SCM_UNSPECIFIED;
}

SCM
reader_get_attribute(SCM smob, SCM arg1, SCM arg2)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);

    if (!(scm_is_string(arg1) || scm_is_integer(arg1)))
        scm_wrong_type_arg("xml/get-attribute", 1, arg1);

    if (scm_is_integer(arg1))
        return scm_from_locale_string(reader->get_attribute(scm_to_int(arg1)).data());

    if (!SCM_UNBNDP(arg2))
        return scm_from_locale_string(reader->get_attribute(scm_to_locale_string(arg1)).data());

    if (!(scm_is_string(arg2)))
        scm_wrong_type_arg("xml/get-attribute", 2, arg2);

    return scm_from_locale_string(reader->get_attribute(scm_to_locale_string(arg1),
                                                        scm_to_locale_string(arg2)).data());
}


SCM
reader_lookup_namespace(SCM smob, SCM prefix)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);

    if (!(scm_is_string(prefix)))
        scm_wrong_type_arg("xml/get-attribute", 1, prefix);

    return scm_from_locale_string(reader->lookup_namespace(scm_to_locale_string(prefix)).data());
}


SCM
reader_move_to_attribute(SCM smob, SCM arg1, SCM arg2)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);

    if (!(scm_is_string(arg1) || scm_is_integer(arg1)))
        scm_wrong_type_arg("xml/move-to-attribute", 1, arg1);

    if (scm_is_integer(arg1))
        return scm_from_bool(reader->move_to_attribute(scm_to_int(arg1)));

    if (!SCM_UNBNDP(arg2))
        return scm_from_bool(reader->move_to_attribute(scm_to_locale_string(arg1)));

    if (!(scm_is_string(arg2)))
        scm_wrong_type_arg("xml/move-to-attribute", 2, arg2);

    return scm_from_bool(reader->move_to_attribute(scm_to_locale_string(arg1),
                                                   scm_to_locale_string(arg2)));
}


SCM
reader_move_to_first_attribute(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_bool(reader->move_to_first_attribute());
}

SCM
reader_move_to_next_attribute(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_bool(reader->move_to_next_attribute());
}

SCM
reader_move_to_element(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_bool(reader->move_to_element());
}

SCM
reader_get_normalization(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_bool(reader->get_normalization());
}

#if 0
SCM
reader_set_normalization(SCM smob, SCM value)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);

    if (!(scm_is_bool(value)))
        scm_wrong_type_arg("xml/set-normalization", 1, value);

    reader->set_normalization(scm_to_bool(value));
    return SCM_UNSPECIFIED;
}
#endif

SCM
reader_get_parser_property(SCM smob, SCM property)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_bool(reader->get_parser_property(static_cast<TextReader::ParserProperties>(scm_to_int(property))));
}

SCM
reader_set_parser_property(SCM smob, SCM property, SCM value)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    reader->set_parser_property(static_cast<TextReader::ParserProperties>(scm_to_int(property)),
                                (bool)scm_to_bool(value));
    return SCM_UNSPECIFIED;
}

SCM
reader_get_current_node(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_pointer(reader->get_current_node(), NULL);
}

SCM
reader_expand(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_pointer(reader->expand(), NULL);
}

SCM
reader_next(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_bool(reader->next());
}

SCM
reader_is_valid(SCM smob)
{
    scm_assert_smob_type(scm_textreader_tag, smob);
    TextReader* reader = (TextReader*) SCM_SMOB_DATA(smob);
    return scm_from_bool(reader->is_valid());
}


void
register_textreader_functions()
{
    scm_c_define_gsubr("xml/make-reader-from-file", 1, 0, 0, (void*)make_reader_with_file);
    scm_c_define_gsubr("xml/make-reader-from-string", 1, 0, 0, (void*)make_reader_with_string);

    scm_c_define_gsubr("xml/read", 1, 0, 0, (void*)reader_read);
    scm_c_define_gsubr("xml/read-inner-xml", 1, 0, 0, (void*)reader_read_inner_xml);
    scm_c_define_gsubr("xml/read-outer-xml", 1, 0, 0, (void*)reader_read_outer_xml);
    scm_c_define_gsubr("xml/read-string", 1, 0, 0, (void*)reader_read_string);
    scm_c_define_gsubr("xml/read-attribute-value", 1, 0, 0, (void*)reader_read_attribute_value);
    scm_c_define_gsubr("xml/get-attribute-count", 1, 0, 0, (void*)reader_get_attribute_count);
    scm_c_define_gsubr("xml/get-base-uri", 1, 0, 0, (void*)reader_get_base_uri);
    scm_c_define_gsubr("xml/get-depth", 1, 0, 0, (void*)reader_get_depth);
    scm_c_define_gsubr("xml/has-attributes", 1, 0, 0, (void*)reader_has_attributes);
    scm_c_define_gsubr("xml/has-value", 1, 0, 0, (void*)reader_has_value);
    scm_c_define_gsubr("xml/is-default", 1, 0, 0, (void*)reader_is_default);
    scm_c_define_gsubr("xml/is-empty-element", 1, 0, 0, (void*)reader_is_empty_element);
    scm_c_define_gsubr("xml/get-local-name", 1, 0, 0, (void*)reader_get_local_name);
    scm_c_define_gsubr("xml/get-name", 1, 0, 0, (void*)reader_get_name);
    scm_c_define_gsubr("xml/get-namespace-uri", 1, 0, 0, (void*)reader_get_namespace_uri);
    scm_c_define_gsubr("xml/get-node-type", 1, 0, 0, (void*)reader_get_node_type);
    scm_c_define_gsubr("xml/get-prefix", 1, 0, 0, (void*)reader_get_prefix);
    scm_c_define_gsubr("xml/get-quote-char", 1, 0, 0, (void*)reader_get_quote_char);
    scm_c_define_gsubr("xml/get-value", 1, 0, 0, (void*)reader_get_value);
    scm_c_define_gsubr("xml/get-xml-lang", 1, 0, 0, (void*)reader_get_xml_lang);
    scm_c_define_gsubr("xml/get-read-state", 1, 0, 0, (void*)reader_get_read_state);
    scm_c_define_gsubr("xml/close", 1, 0, 0, (void*)reader_close);
    scm_c_define_gsubr("xml/get-attribute", 2, 1, 0, (void*)reader_get_attribute);
    scm_c_define_gsubr("xml/lookup-namespace", 2, 0, 0, (void*)reader_lookup_namespace);
    scm_c_define_gsubr("xml/move-to-attribute", 2, 1, 0, (void*)reader_move_to_attribute);
    scm_c_define_gsubr("xml/move-to-first-attribute", 1, 0, 0, (void*)reader_move_to_first_attribute);
    scm_c_define_gsubr("xml/move-to-next-attribute", 1, 0, 0, (void*)reader_move_to_next_attribute);
    scm_c_define_gsubr("xml/move-to-element", 1, 0, 0, (void*)reader_move_to_element);
    scm_c_define_gsubr("xml/get-normalization", 1, 0, 0, (void*)reader_get_normalization);
#if 0
    scm_c_define_gsubr("xml/set-normalization", 2, 0, 0, (void*)reader_set_normalization);
#endif
    scm_c_define_gsubr("xml/get-parser-property", 2, 0, 0, (void*)reader_get_parser_property);
    scm_c_define_gsubr("xml/set-parser-property", 3, 0, 0, (void*)reader_set_parser_property);
    scm_c_define_gsubr("xml/get-current-node", 1, 0, 0, (void*)reader_get_current_node);
    scm_c_define_gsubr("xml/expand", 1, 0, 0, (void*)reader_expand);
    scm_c_define_gsubr("xml/next", 1, 0, 0, (void*)reader_next);
    scm_c_define_gsubr("xml/is-valid", 1, 0, 0, (void*)reader_is_valid);
}

#ifdef __cplusplus
extern "C"
#endif
void init_xmlreader(void)
{
    static bool registered = false;

    if (registered)
        return;

    std::locale::global(std::locale(""));
    // scm_c_eval_string("(setlocale LC_ALL \"\")");

    // for LIBXML++
    init_textreader_type();
    register_textreader_constants();
    register_textreader_functions();

    registered = true;
}
