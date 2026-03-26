{ pkgs, ... }:
let
  pythonEnv = pkgs.python3.withPackages (ps: [ ps.pygobject3 ]);

  trayDeps = with pkgs; [
    libappindicator-gtk3
    gtk3
    gobject-introspection
    librsvg
    pango.out
    gdk-pixbuf
    at-spi2-core
    harfbuzz
  ];

  dockerTrayScript = pkgs.writeTextFile {
    name = "docker-tray";
    executable = true;
    text = ''
      #!${pythonEnv}/bin/python3
      import gi
      gi.require_version("Gtk", "3.0")
      gi.require_version("AppIndicator3", "0.1")
      from gi.repository import Gtk, AppIndicator3, GLib
      import subprocess
      import json


      class DockerTray:
          def __init__(self):
              self.indicator = AppIndicator3.Indicator.new(
                  "docker-tray",
                  "docker",
                  AppIndicator3.IndicatorCategory.APPLICATION_STATUS,
              )
              self.indicator.set_status(AppIndicator3.IndicatorStatus.ACTIVE)
              self.update()
              GLib.timeout_add_seconds(10, self.update)

          def get_containers(self):
              try:
                  result = subprocess.run(
                      ["docker", "ps", "--format", "json"],
                      capture_output=True,
                      text=True,
                      timeout=5,
                  )
                  if result.returncode != 0:
                      return None
                  lines = result.stdout.strip().split("\n")
                  return [json.loads(line) for line in lines if line]
              except Exception:
                  return None

          def update(self):
              menu = Gtk.Menu()
              containers = self.get_containers()

              if containers is None:
                  item = Gtk.MenuItem(label="Docker indisponivel")
                  item.set_sensitive(False)
                  menu.append(item)
              elif not containers:
                  item = Gtk.MenuItem(label="Nenhum container rodando")
                  item.set_sensitive(False)
                  menu.append(item)
              else:
                  header = Gtk.MenuItem(
                      label=f"{len(containers)} container(s) rodando"
                  )
                  header.set_sensitive(False)
                  menu.append(header)
                  menu.append(Gtk.SeparatorMenuItem())
                  for c in containers:
                      name = c.get("Names", "?")
                      image = c.get("Image", "?")
                      status = c.get("Status", "?")
                      label = f"{name}  |  {image}  |  {status}"
                      item = Gtk.MenuItem(label=label)
                      item.set_sensitive(False)
                      menu.append(item)

              menu.append(Gtk.SeparatorMenuItem())
              quit_item = Gtk.MenuItem(label="Fechar")
              quit_item.connect("activate", lambda _: Gtk.main_quit())
              menu.append(quit_item)

              menu.show_all()
              self.indicator.set_menu(menu)
              return True


      DockerTray()
      Gtk.main()
    '';
  };
in
{
  systemd.user.services.docker-tray = {
    Unit = {
      Description = "Docker system tray icon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${dockerTrayScript}";
      Restart = "on-failure";
      RestartSec = 5;
      Environment = [
        "GI_TYPELIB_PATH=${pkgs.lib.makeSearchPath "lib/girepository-1.0" trayDeps}"
        "LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath trayDeps}"
      ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
