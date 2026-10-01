> **Currently Pre-Alpha**

![orza icon](docs/orza.svg)

# Orza

## Orza Browser

A secure and distraction-free browser. Built to protect you from ads and trackers.

Orza comes with a built-in tracker blocker, ad blocker, and randomizer. These features are designed to reduce unwanted tracking and distractions while keeping the browsing experience focused. Orza is built for people who want their browser to stay out of the way and let them get their work done with greater privacy and peace of mind.

### Architecture

Typical Chromium-based browsers are developed by compiling the Chromium codebase and integrating additional components around the resulting binaries. Orza takes a different approach by sidestepping from this practice.

Orza operates around pre-compiled browser binary components, reducing the development and maintenance workload. 
Chromium-based browsers store certain resources and data in `.pak` files which are separate from the compiled binaries and for many resources, that are independent of the target architecture, amd64 and arm64.
By modifying these `.pak` files and repackaging the surrounding components, Orza can modify the supported aspects of the browser without recompiling the underlying Chromium codebase.

Security is another fundamental part of Orza's architecture. Orza is designed to integrate with Linux Security Modules (LSMs) such as SELinux and AppArmor. These allow security policies to restrict the browser's access to files, devices, capabilities, and other system resources. These LSMs generally wrap around the program rather than being written inside of it to not get manipulated by the program it has to confine.


### Security on GNU/Linux

A browser is not just a simple application. It processes untrusted content, executes complex code, accesses the filesystem, communicates over networks, and interacts with numerous system resources. With that level of access and complexity, the security boundaries provided by the operating system matter.

Many browsers rely on established packaging and distribution templates for their GNU/Linux builds. In some configurations, these approaches do not provide browser-specific LSM policies, or may require security restrictions to be relaxed to avoid compatibility issues and runtime failures.

As a result, the browser process may operate with fewer mandatory access-control restrictions than intended. This increases the amount of access available to a compromised browser process and can weaken the system's overall security boundary.


- ie. chromium linux packaging template specifically disables AppArmor profile and has nothing for SELinux which sets the policy to `unconfined_t`. 

Orza is built specifically for GNU/Linux with these security mechanisms in mind. Rather than treating system security profiles and policies as something added after the browser is packaged, Orza is designed around integrating with them as part of its architecture.


## License
Orza is licensed under Mozilla Public License v2.0. See [LICENSE](LICENSE). Third party components that are present or utilized is subject to its own licensing.


## Current Status

Orza is currently in **pre-alpha**. The project is still establishing its foundations, including its packaging, architecture, security integration, and core browser infrastructure. Significant changes should therefore be expected during development.
