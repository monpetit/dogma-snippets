#include <gtk/gtk.h>


G_MODULE_EXPORT void
on_button_start_clicked(GtkObject *object, gpointer user_data)
{
    puts("시작 버튼을 눌렀습니다.");
}


G_MODULE_EXPORT void
on_button_pause_clicked(GtkObject *object, gpointer user_data)
{
    puts("일시정지 버튼을 눌렀습니다.");
}

G_MODULE_EXPORT void
on_button_stop_clicked(GtkObject *object, gpointer user_data)
{
    puts("멈춤 버튼을 눌렀습니다.");
}


int
main( int    argc,
      char **argv )
{
    GtkBuilder *builder;
    GtkWidget  *window;
    GError     *error = NULL;
    GtkButton  *start_button;
    GtkButton  *pause_button;
    GtkButton  *stop_button;

    /* Init GTK+ */
    gtk_init( &argc, &argv );

    /* Create new GtkBuilder object */
    builder = gtk_builder_new();
    /* Load UI from file. If error occurs, report it and quit application.
     * Replace "tut.glade" with your saved project. */
    if( ! gtk_builder_add_from_file( builder, "main_window.glade", &error ) )
    {
        g_warning( "%s", error->message );
        g_free( error );
        return( 1 );
    }

    /* Get main window pointer from UI */
    window = GTK_WIDGET( gtk_builder_get_object( builder, "main_window" ) );
    start_button = (GtkButton*)GTK_WIDGET( gtk_builder_get_object( builder, "button_start" ) );
    pause_button = (GtkButton*)GTK_WIDGET( gtk_builder_get_object( builder, "button_pause" ) );
    stop_button  = (GtkButton*)GTK_WIDGET( gtk_builder_get_object( builder, "button_stop" ) );


    /* Connect signals */
    gtk_builder_connect_signals( builder, NULL );
    g_signal_connect (start_button, "clicked", G_CALLBACK(on_button_start_clicked), NULL);
    g_signal_connect (pause_button, "clicked", G_CALLBACK(on_button_pause_clicked), NULL);
    g_signal_connect (stop_button,  "clicked", G_CALLBACK(on_button_stop_clicked), NULL);

    /* Destroy builder, since we don't need it anymore */
    g_object_unref( G_OBJECT( builder ) );

    /* Show window. All other widgets are automatically shown by GtkBuilder */
    gtk_widget_show( window );

    /* Start main loop */
    gtk_main();

    return( 0 );
}
