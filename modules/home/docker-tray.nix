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

  dockerIcon = pkgs.writeTextFile {
    name = "docker-tray-icon";
    destination = "/docker-tray.svg";
    text = ''
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 512" width="48" height="48">
        <path fill="#cdd6f4" d="M349.9 236.3h-66.1v-59.4h66.1v59.4zm0-204.3h-66.1v60.7h66.1V32zm78.2 144.8H362v59.4h66.1v-59.4zm-156.3-72.1h-66.1v60.1h66.1v-60.1zm78.1 0h-66.1v60.1h66.1v-60.1zm276.8 100c-14.4-9.7-47.6-13.2-73.1-8.4-3.3-24-16.7-44.9-41.1-63.7l-14-9.3-9.3 14c-18.4 27.8-23.4 73.6-3.7 103.8-8.7 4.7-25.8 11.1-48.4 10.7H2.4c-7.6 42.6-4.7 124.4 52.4 193.5 54.7 66.3 136.5 100.2 243.7 100.2 130.2 0 226.6-60.1 271.4-169.2C602.4 338 632.8 333.6 640 268.8l.8-6.5-14.7-9.9zM271.6 32h-66.1v60.7h66.1V32zm-78.2 72.1h-66.1v60.1h66.1v-60.1zm0 72.1h-66.1v59.4h66.1v-59.4zm-78.1-72.1H49.2v60.1h66.1v-60.1z"/>
      </svg>
    '';
  };

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
              self.indicator = AppIndicator3.Indicator.new_with_path(
                  "docker-tray",
                  "docker-tray",
                  AppIndicator3.IndicatorCategory.APPLICATION_STATUS,
                  "${dockerIcon}",
              )
              self.indicator.set_status(AppIndicator3.IndicatorStatus.ACTIVE)
              self.indicator.set_title("Docker")
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

          def build_tooltip(self, containers):
              if containers is None:
                  return "Docker indisponivel"
              if not containers:
                  return "Nenhum container rodando"
              lines = [f"{len(containers)} container(s) rodando", ""]
              for c in containers:
                  name = c.get("Names", "?")
                  image = c.get("Image", "?")
                  status = c.get("Status", "?")
                  lines.append(f"{name} | {image} | {status}")
              return "\n".join(lines)

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

              tooltip = self.build_tooltip(containers)
              self.indicator.set_title(tooltip)

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
