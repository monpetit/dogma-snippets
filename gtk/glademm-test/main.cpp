#include <gtkmm.h>
#include <iostream>

G_MODULE_EXPORT
void on_button_start_clicked(void)
{
    puts("시작 버튼을 눌렀습니다.");
}

G_MODULE_EXPORT
void on_button_pause_clicked(void)
{
    puts("일시정지 버튼을 눌렀습니다.");
}

G_MODULE_EXPORT
void on_button_stop_clicked(void)
{
    puts("멈춤 버튼을 눌렀습니다.");
}


int main(int argc, char *argv[])
{
    Gtk::Main kit(argc, argv);

    Glib::RefPtr<Gtk::Builder> builder = Gtk::Builder::create_from_file("main_window.glade");

    Gtk::Window* window;
    builder->get_widget("main_window", window);

    Gtk::Button* start_button;
    Gtk::Button* pause_button;
    Gtk::Button* stop_button;
    Gtk::Button* exit_button;

    builder->get_widget("button_start", start_button);
    builder->get_widget("button_pause", pause_button);
    builder->get_widget("button_stop",  stop_button);
    builder->get_widget("button_exit",  exit_button);

    // window->signal_delete_event().connect(sigc::ptr_fun(&_quit));
    start_button->signal_clicked().connect(sigc::ptr_fun(&on_button_start_clicked));
    pause_button->signal_clicked().connect(sigc::ptr_fun(&on_button_pause_clicked));
    stop_button->signal_clicked().connect(sigc::ptr_fun(&on_button_stop_clicked));
    exit_button->signal_clicked().connect(sigc::ptr_fun(&gtk_main_quit));


    kit.run(*window);
    // Gtk::Main::run(*window);

    return 0;
}
