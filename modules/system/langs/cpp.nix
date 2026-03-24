{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gcc
    clang
    llvmPackages.llvm
    cmake
    ninja
  ];
}
