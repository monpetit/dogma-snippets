
(use-modules (system foreign))
(use-modules (rnrs bytevectors))
(use-modules (dogma-ffi))

(define libxml (dynamic-link "./libguile-xmlreader"))

(define xml/create-reader-file
  (lambda (filename)
    (let ((f (c-func libxml '* 'create_reader_from_file '*)))
      (f (string->pointer filename)))))

(define xml/create-reader-string
  (lambda (text size)
    (let ((f (c-func libxml '* 'create_reader_from_string '* size_t)))
      (f (string->pointer text) size))))

(define xml/release-reader (c-func libxml void 'release_reader '*))
(define xml/read (c-func libxml int8 'text_read '*))

(define xml/read-inner-xml
  (lambda (reader)
    (pointer->string ((c-func libxml '* 'text_read_inner_xml '*) reader))))

(define xml/read-outer-xml
  (lambda (reader)
    (pointer->string ((c-func libxml '* 'text_read_outer_xml '*) reader))))

(define xml/read-string
  (lambda (reader)
    (pointer->string ((c-func libxml '* 'text_read_string '*) reader))))



(define xml/read-attribute-value (c-func libxml int8 'text_read_attribute_value '*))
(define xml/get-attribute-count (c-func libxml int 'text_get_attribute_count '*))
(define xml/get-base-uri
  (lambda (reader)
    (pointer->string ((c-func libxml '* 'text_get_base_uri '*) reader))))

(define xml/get-depth (c-func libxml int 'text_get_depth '*))
(define xml/has-attributes (c-func libxml int8 'text_has_attributes '*))
(define xml/has-value (c-func libxml int8 'text_has_value '*))
(define xml/is-default (c-func libxml int8 'text_is_default '*))
(define xml/is-empty-element (c-func libxml int8 'text_is_empty_element '*))

(define xml/get-local-name
  (lambda (reader)
    (pointer->string ((c-func libxml '* 'text_get_local_name '*) reader))))

(define xml/get-name
  (lambda (reader)
    (pointer->string ((c-func libxml '* 'text_get_name '*) reader))))

(define xml/get-namespace-uri
  (lambda (reader)
    (pointer->string ((c-func libxml '* 'text_get_namespace_uri '*) reader))))

(define xml/get-node-type (c-func libxml int8 'text_get_node_type '*))

(define xml/get-prefix
  (lambda (reader)
    (pointer->string ((c-func libxml '* 'text_get_prefix '*) reader))))

(define xml/get-quote-char
  (lambda (reader)
    (integer->char (c-func libxml int8 'text_get_quote_char '*))))

(define xml/get-value
  (lambda (reader)
    (pointer->string ((c-func libxml '* 'text_get_value '*) reader))))

(define xml/get-xml-lang
  (lambda (reader)
    (pointer->string ((c-func libxml '* 'text_get_xml_lang '*) reader))))

(define xml/get-read-state (c-func libxml int8 'text_get_read_state '*))
(define xml/close (c-func libxml void 'text_close '*))

(define xml/get-attribute
  (case-lambda
   ((reader x)
    (if (integer? x)
        (pointer->string ((c-func libxml '* 'text_get_attribute_int '* int) reader x))
        (pointer->string ((c-func libxml '* 'text_get_attribute_name '* '*) reader (string->pointer x)))))
   ((reader x y)
    (pointer->string ((c-func libxml '* 'text_get_attribute_local_name '* '* '*)
                      reader
                      (string->pointer x)
                      (string->pointer y))))))

(define xml/lookup-namespace
  (lambda (reader prefix)
    (pointer->string ((c-func libxml '* 'text_lookup_namespace '* '*)
                      reader
                      (string->pointer prefix)))))

(define xml/move-to-attribute
  (case-lambda
   ((reader x)
    (if (integer? x)
        ((c-func libxml int8 'text_move_to_attribute_int '* int) reader x)
        ((c-func libxml int8 'text_move_to_attribute_name '* '*) reader (string->pointer x))))
   ((reader x y)
    ((c-func libxml int8 'text_move_to_attribute_local_name '* '* '*)
     reader
     (string->pointer x)
     (string->pointer y)))))

(define xml/move-to-first-attribute (c-func libxml int8 'text_move_to_first_attribute '*))
(define xml/move-to-next-attribute (c-func libxml int8 'text_move_to_next_attribute '*))
(define xml/move-to-element (c-func libxml int8 'text_move_to_element '*))
(define xml/get-normalization (c-func libxml int8 'text_get_normalization '*))
(define xml/set-normalization (c-func libxml void 'text_set_normalization '* int8))
(define xml/get-parser-property (c-func libxml int8 'text_get_parser_property '* int8))
(define xml/set-parser-property (c-func libxml int8 'text_set_parser_property '* int8 int8))
(define xml/get-current-node (c-func libxml '* 'text_get_current_node '*))
(define xml/expand (c-func libxml '* 'text_expand '*))
(define xml/next (c-func libxml int8 'text_next '*))
(define xml/is_valid (c-func libxml int8 'text_is_valid '*))


(define *xmlNodeType/Attribute* 2)
(define *xmlNodeType/CDATA* 4)
(define *xmlNodeType/Comment* 8)
(define *xmlNodeType/Document* 9)
(define *xmlNodeType/DocumentFragment* 11)
(define *xmlNodeType/DocumentType* 10)
(define *xmlNodeType/Element* 1)
(define *xmlNodeType/EndElement* 15)
(define *xmlNodeType/EndEntity* 16)
(define *xmlNodeType/Entity* 6)
(define *xmlNodeType/EntityReference* 5)
(define *xmlNodeType/None* 0)
(define *xmlNodeType/Notation* 12)
(define *xmlNodeType/ProcessingInstruction* 7)
(define *xmlNodeType/SignificantWhitespace* 14)
(define *xmlNodeType/Text* 3)
(define *xmlNodeType/Whitespace* 13)
(define *xmlNodeType/XmlDeclaration* 17)

(define *xmlReadState/Closed* 4)
(define *xmlReadState/EndOfFile* 3)
(define *xmlReadState/Error* 2)
(define *xmlReadState/Initial* 0)
(define *xmlReadState/Interactive* 1)
(define *xmlReadState/Reading* 5)

(define *ParserProperties/LoadDtd* 1)
(define *ParserProperties/DefaultAttrs* 2)
(define *ParserProperties/Validate* 3)
(define *ParserProperties/SubstEntities* 4)
