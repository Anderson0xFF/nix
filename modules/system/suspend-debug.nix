{ pkgs, ... }:
{
  # Serviço temporário para diagnosticar problemas de suspend/resume.
  # Loga estado da memória e processos antes de suspender e ao acordar.
  # Logs em: /var/log/suspend-debug.log
  # Remover este módulo após resolver o problema.
  systemd.services.suspend-debug = {
    description = "Log system state before suspend and after resume";
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    path = [ pkgs.coreutils pkgs.procps pkgs.gnugrep ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "suspend-debug-pre" ''
        echo "=== PRE-SUSPEND $(date -Iseconds) ===" >> /var/log/suspend-debug.log
        free -h >> /var/log/suspend-debug.log
        echo "--- Top 15 processos por memória ---" >> /var/log/suspend-debug.log
        ps aux --sort=-%mem | head -16 >> /var/log/suspend-debug.log
        echo "" >> /var/log/suspend-debug.log
      '';
      ExecStop = pkgs.writeShellScript "suspend-debug-post" ''
        echo "=== POST-RESUME $(date -Iseconds) ===" >> /var/log/suspend-debug.log
        free -h >> /var/log/suspend-debug.log
        echo "--- Top 15 processos por memória ---" >> /var/log/suspend-debug.log
        ps aux --sort=-%mem | head -16 >> /var/log/suspend-debug.log
        echo "--- Processos code/electron ---" >> /var/log/suspend-debug.log
        ps aux | grep -iE "[c]ode|[e]lectron" >> /var/log/suspend-debug.log 2>&1 || echo "(nenhum encontrado)" >> /var/log/suspend-debug.log
        echo "" >> /var/log/suspend-debug.log
      '';
      RemainAfterExit = true;
    };
  };
}
