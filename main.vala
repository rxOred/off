//use Gtk;

public class Application : Gtk.Window {

	public Application() {
		var css_provider = new Gtk.CssProvider();
		if (FileUtils.test("/usr/share/themes/off/theme.css", FileTest.EXISTS)) {
			try {
				css_provider.load_from_path("/usr/share/themes/off/theme.css");
				Gtk.StyleContext.add_provider_for_screen(
					this.get_screen(),
					css_provider,
					Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
				);
			} catch (Error e) {
				stdout.printf("failed to load the stylesheet /home/rxored/repos/off/theme.css : %s", e.message);
				error(e.message);
			}
		} else {
			error("cannot find the stylesheet /home/rxored/repos/off/theme.css");
		}
		
		this.get_style_context().add_class("app");
		this.window_position = Gtk.WindowPosition.CENTER;
		this.destroy.connect(Gtk.main_quit);
		this.set_default_size(280, 70);
		this.set_resizable(false);
		//this.key_press_event(Gtk.main_quit);
		
		this.set_events(Gdk.EventMask.KEY_PRESS_MASK);		
		
		Gtk.Button poweroff_button = new Gtk.Button.with_label("  ");
		poweroff_button.get_style_context().add_class("button");

		Gtk.Button restart_button = new Gtk.Button.with_label("  ");
		restart_button.get_style_context().add_class("button");
	 
		Gtk.Button logout_button = new Gtk.Button.with_label("  ");
		logout_button.get_style_context().add_class("button");
		
		poweroff_button.clicked.connect(on_poweroff_clicked);
		restart_button.clicked.connect(on_restart_clicked);
		logout_button.clicked.connect(on_logout_clicked);
		
		Gtk.Box box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
		box.set_homogeneous(true); 

	    box.pack_start(poweroff_button, true, true, 0);
		box.pack_start(restart_button, true, true, 0);
	    box.pack_start(logout_button, true, true, 0);
		box.key_press_event.connect(on_keypress);
		
		this.add(box);	
	}

	private bool on_keypress(Gdk.EventKey event) {
		if (event.key.keyval == Gdk.Key.Escape) {
			Gtk.main_quit();
		}
		return false;
	}
	
	private void on_poweroff_clicked() {
		Posix.system("shutdown -P now");
	}

	private void on_restart_clicked() {
		Posix.system("shutdown -r now");
	}

	private void on_logout_clicked() {
		Posix.system("xfce4-session-logout --logout");
	}
}

int main(string[] args) {
	Gtk.init(ref args);
	Application app = new Application();
	app.show_all();
	Gtk.main();
	return 0;
}