#ifndef XMLTEXT_H
#define XMLTEXT_H

#include <libxml++/libxml++.h>
#include <glibmm.h>

using namespace xmlpp;
using namespace Glib;


#ifdef __cplusplus
extern "C" {
#endif

TextReader* create_reader_from_file(const char* filename);
TextReader* create_reader_from_string(const unsigned char *text, size_t size);
void    release_reader(TextReader* reader);
bool    text_read(TextReader* reader);
const char* text_read_inner_xml(TextReader* reader);
const char* text_read_outer_xml(TextReader* reader);
const char* text_read_string(TextReader* reader);
bool    text_read_attribute_value(TextReader* reader);
int 	text_get_attribute_count(TextReader* reader);
const char* text_get_base_uri(TextReader* reader);
int     text_get_depth(TextReader* reader);
bool 	text_has_attributes(TextReader* reader);
bool 	text_has_value(TextReader* reader);
bool 	text_is_default(TextReader* reader);
bool 	text_is_empty_element(TextReader* reader);
const char* 	text_get_local_name(TextReader* reader);
const char* 	text_get_name(TextReader* reader);
const char* 	text_get_namespace_uri(TextReader* reader);
TextReader::xmlNodeType text_get_node_type(TextReader* reader);
const char* 	text_get_prefix(TextReader* reader);
char 	text_get_quote_char(TextReader* reader);
const char* 	text_get_value(TextReader* reader);
const char* 	text_get_xml_lang(TextReader* reader);
TextReader::xmlReadState 	text_get_read_state(TextReader* reader);
void 	text_close (TextReader* reader);
const char* 	text_get_attribute_int(TextReader* reader, int number);
const char* 	text_get_attribute_name(TextReader* reader, const char* name);
const char* 	text_get_attribute_local_name(TextReader* reader, const char* local_name, const char* ns_uri);
const char* 	text_lookup_namespace (TextReader* reader, const char* prefix);
bool 	text_move_to_attribute_int(TextReader* reader, int number);
bool 	text_move_to_attribute_name(TextReader* reader, const char* name);
bool 	text_move_to_attribute_local_name(TextReader* reader, const char* local_name, const char* ns_uri);
bool 	text_move_to_first_attribute(TextReader* reader);
bool 	text_move_to_next_attribute(TextReader* reader);
bool 	text_move_to_element(TextReader* reader);
bool 	text_get_normalization(TextReader* reader);
void 	text_set_normalization(TextReader* reader, bool value);
bool 	text_get_parser_property(TextReader* reader, TextReader::ParserProperties property);
void 	text_set_parser_property(TextReader* reader, TextReader::ParserProperties property, bool value);
Node* 	text_get_current_node(TextReader* reader);
Node* 	text_expand(TextReader* reader);
bool 	text_next(TextReader* reader);
bool 	text_is_valid(TextReader* reader);

#ifdef __cplusplus
}
#endif

#endif // XMLTEXT_H
