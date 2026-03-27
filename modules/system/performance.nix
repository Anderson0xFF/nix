{ ... }:
{
  # Kernel sysctl tuning
  boot.kernel.sysctl = {
    # Memória - menos agressivo em usar swap com 48GB RAM
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
    "vm.page-cluster" = 0;

    # Rede - TCP BBR para melhor throughput
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";

    # Filesystem - importante para IDEs e file watchers
    "fs.inotify.max_user_watches" = 1048576;
    "fs.file-max" = 2097152;
  };

  # Zram - swap comprimido na RAM (~12GB)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  # EarlyOOM - previne travamento total por falta de RAM
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 5;
    enableNotifications = true;
    extraArgs = [
      "--avoid" "(^|/)(code|code-oss|codium|electron)$"
    ];
  };

  # /tmp na RAM - compilações mais rápidas
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
  };

  # NVMe não precisa de I/O scheduler
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
  '';

  # GameMode - otimiza prioridade e GPU para jogos
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
        softrealtime = "auto";
        inhibit_screensaver = 0;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
    };
  };
}
