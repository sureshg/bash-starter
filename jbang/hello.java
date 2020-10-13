///usr/bin/env curl -LSs https://sh.jbang.dev | bash -eo pipefail -s - "$0" "$@"; exit $?
//
// Self-runnable .java file using zero-install jbang.... Download this file `hello.java`,
// mark it as executable and run it as ./hello.java - works on linux, osx and windows bash
// as long as you have curl installed.
class hello {

  public static void main(String[] args) {
    System.out.println("Hello from JBang!");
  }
}