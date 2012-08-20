#include "xmltext.h"
#include <iostream>


TextReader* create_reader_from_file(const char* filename)
{
    return new TextReader(ustring(filename));
}

TextReader* create_reader_from_string(const unsigned char* text, size_t size)
{
    return new TextReader(text, size);
}

void
release_reader(TextReader* reader)
{
    delete reader;
}


bool
text_read(TextReader* reader)
{
    return reader->read();
}


const char*
text_read_inner_xml(TextReader* reader)
{
    return reader->read_inner_xml().data();
}


const char*
text_read_outer_xml(TextReader* reader)
{
    return reader->read_outer_xml().data();
}


const char*
text_read_string(TextReader* reader)
{
    return reader->read_string().data();
}


bool
text_read_attribute_value(TextReader* reader)
{
    return reader->read_attribute_value();
}


int
text_get_attribute_count(TextReader* reader)
{
    return reader->get_attribute_count();
}


const char*
text_get_base_uri(TextReader* reader)
{
    return reader->get_base_uri().data();
}


int
text_get_depth(TextReader* reader)
{
    return reader->get_depth();
}


bool
text_has_attributes(TextReader* reader)
{
    return reader->has_attributes();
}


bool
text_has_value(TextReader* reader)
{
    return reader->has_value();
}


bool
text_is_default(TextReader* reader)
{
    return reader->is_default();
}


bool
text_is_empty_element(TextReader* reader)
{
    return reader->is_empty_element();
}


const char*
text_get_local_name(TextReader* reader)
{
    return reader->get_local_name().data();
}


const char*
text_get_name(TextReader* reader)
{
    return reader->get_name().data();
}


const char*
text_get_namespace_uri(TextReader* reader)
{
    return reader->get_namespace_uri().data();
}


TextReader::xmlNodeType text_get_node_type(TextReader* reader)
{
    return reader->get_node_type();
}


const char*
text_get_prefix(TextReader* reader)
{
    return reader->get_prefix().data();
}


char
text_get_quote_char(TextReader* reader)
{
    return reader->get_quote_char();
}


const char*
text_get_value(TextReader* reader)
{
    return reader->get_value().data();
}


const char*
text_get_xml_lang(TextReader* reader)
{
    return reader->get_xml_lang().data();
}


TextReader::xmlReadState
text_get_read_state(TextReader* reader)
{
    return reader->get_read_state();
}


void
text_close (TextReader* reader)
{
    reader->close();
}


const char*
text_get_attribute_int(TextReader* reader, int number)
{
    return reader->get_attribute(number).data();
}


const char*
text_get_attribute_name(TextReader* reader, const char* name)
{
    return reader->get_attribute(name).data();
}


const char*
text_get_attribute_local_name(TextReader* reader, const char* local_name, const char* ns_uri)
{
    return reader->get_attribute(local_name, ns_uri).data();
}


const char*
text_lookup_namespace (TextReader* reader, const char* prefix)
{
    return reader->lookup_namespace(prefix).data();
}


bool
text_move_to_attribute_int(TextReader* reader, int number)
{
    return reader->move_to_attribute(number);
}


bool
text_move_to_attribute_name(TextReader* reader, const char* name)
{
    return reader->move_to_attribute(name);
}


bool
text_move_to_attribute_local_name(TextReader* reader, const char* local_name, const char* ns_uri)
{
    return reader->move_to_attribute(local_name, ns_uri);
}


bool
text_move_to_first_attribute(TextReader* reader)
{
    return reader->move_to_first_attribute();
}


bool
text_move_to_next_attribute(TextReader* reader)
{
    return reader->move_to_next_attribute();
}


bool
text_move_to_element(TextReader* reader)
{
    return reader->move_to_element();
}


bool
text_get_normalization(TextReader* reader)
{
    return reader->get_normalization();
}


void
text_set_normalization(TextReader* reader, bool value)
{
    reader->set_normalization(value);
}


bool
text_get_parser_property(TextReader* reader, TextReader::ParserProperties property)
{
    return reader->get_parser_property(property);
}


void
text_set_parser_property(TextReader* reader, TextReader::ParserProperties property, bool value)
{
    reader->set_parser_property(property, value);
}


Node*
text_get_current_node(TextReader* reader)
{
    return reader->get_current_node();
}


Node*
text_expand(TextReader* reader)
{
    return reader->expand();
}


bool
text_next(TextReader* reader)
{
    return reader->next();
}


bool
text_is_valid(TextReader* reader)
{
    return reader->is_valid();
}
