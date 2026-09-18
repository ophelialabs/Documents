---
title: GUI Builders
---

## Popular GUI Builders by Ecosystem
### Blazor Design Systems
Some teams use [Storybook]() to host the CSS/Sass and Design Tokens of their design system while building a seperate Blazor component library that consumes those styles. Tools like [Storybook Connect plugin]() allow you to link your live stories directly to Figma components. [Figma<>Storybook](https://help.figma.com/hc/en-us/articles/360045003494-Storybook-and-Figma#h_01J3N5QKJ9ETAMW9D8395HPHD9) => [QT]() , [TKinter Designer](), **Note**: JPL's [Explorer 1]() design system is primarily built using React and TS. Primary use is React, Vue, Web components not Blazor

  - [MudBlazor](): An open-source library based on Material Design. It is highly customizable with built-in theming support and is a popular choice for building modern enterprise UIs.
  - [Fluent UI](): Microsoft's Official implementation of the [Fluent Design System]() for Blazor, ensuring a consistent look and feel with other modern Microsoft applications. 
  - [Radzen Blazor](): Offers over 70 free components and [Radzen Blazor Studio](), a WYSIWYG designer for creating pages and managing component visual logic.
  - [Blazorize](): A versatile library that allows you to switch between underlying CSS frameworks like Bootstrap, Bulma, or Material Design while keeping your C# code consistent.

#### Recommended Implementation Strategy
  - Host Components in a [Razor Class Library (RCL)](): This allows you to share UI components across multiple projects while keeping them platform-agnostic
  - Use Blazing Story: Integrate this into your RCL to create a live catalog that serves as "living documentation" for your designers and developers
  - Leverage [RenderFragment](): Use this for creating highly flexible, modular components that support nested content and template hooks.

### Python
- PySimpleGUI: Highly recommended for beginners. It wraps Tkinter, Qt, and wxPython, allowing you to define layouts as simple lists of widgets, which dramatically speeds up development.
- NiceGUI: A popular choice for rapid prototyping that lets you create browser-based interfaces (buttons, 3D scenes, plots) directly in Python code without needing HTML or JavaScript knowledge. 
- [Qt Designer]()(PyQt5/PySide6): The industry standard for creating complex, professional PyQt or PySide applications.
    * Creates UI files that are loaded into Python applications.
    * The industry standard for PyQt and PySide. It allows you to drag widgets onto a canvas and saves the design as an .ui XML file, which can be converted to Python code or loaded directly.
    * It is a professional-grade tool that handles complex layouts and multi-window applications efficiently.
- [PyUiBuilder](): A framework-agnostic, web-based drag-and-drop tool. It allows you to visually design interfaces and generate editable Python code for standard Tkinter, CustomTkinter, and other libraries.
    * Multi-framework	Web-based Visual	Agnostic design and rapid export
    * A modern, web-based drag-and-drop tool that is framework-agnostic  
    * It supports multiple libraries like Tkinter and CustomTkinter with planned support for Kivy and PyQt, allowing you to export designs directly into Python code. 
- [Tkinter Designer](): Uses Figma as the design frontend. You design your interface in Figma, and the tool uses the Figma API to convert the design into functional Tkinter code and assets.
- [PyVisual](): A new, user-friendly drag-and-drop builder for Python.
- [Pygubu](): Visual designer for Tkinter, supporting drag-and-drop layout.
    * A "Rapid Application Development" (RAD) tool specifically for Tkinter. It allows you to create UI definition files (XML) that can be loaded directly into your Python scripts. files to define interfaces, similar to how Glade works for GTK.
- [Glade/PyGObject](): RAD tool for GTK+ interfaces, ideal for Linux.
- [PAGE]()(Python Automatic GUI Generator): A drag-and-drop generator specifically for Tkinter, Python's standard GUI library.
    * One of the most established tools for Tkinter. It is a cross-platform generator that resembles Visual Basic and supports both standard Tk and ttk (themed) widgets.
    * A mature, cross-platform tool specifically for Tkinter. It resembles older "Visual Basic" style environments and allows for easy placement of Tk and Ttk widgets.
    * It resembles older Visual Basic environments and is highly effective for building standard Windows-style interfaces.
- [Gooey](): Automatically turns command-line programs into GUI applications with almost no extra code.
- [Anvil](): A web-based drag-and-drop builder for creating full-stack web apps entirely in Python including the UI and the backend.
    * Web apps with zero frontend code
    * Handles hosting and deployment automatically.
- [MD Python Designer](): A commercial-grade designer suite that supports multiple libraries including Tkinter, Kivy, Flet, and PySide2. 
- CustomTkinter Builder: A specialized drag-and-drop editor designed for the CustomTkinter library, which provides a more modern, dark-mode-compatible look compared to standard Tkinter.
- Tkinter GUI Designer (by LabDeck): A commercial-grade component of the MD Python designer package. It provides a specialized IDE with a visual designer that can run multiple GUI instances simultaneously and generate production-ready code.


### Java
- [Scene Builder](): The primary visual layout tool for JavaFX, which uses FXML to keep design separate from application logic.
- [NetBeans GUI Builder (Matisse)](): A well-known built-in tool for the NetBeans IDE that simplifies Swing layout management.
- [WindowBuilder](): A powerful Eclipse plugin that supports both Swing and SWT designers with bi-directional code generation. 

### C / C++ / C#
- [Visual Studio Designer](): Microsoft’s premier tool for WinForms and WPF (XAML) development.
- [Glade Interface Designer](): The dedicated tool for designing GTK+ interfaces, often used for Linux desktop apps. 

### Web & Low-Code GUI Builders 
- Framer / Webflow: Top-tier web design and development tools for creating interactive websites.
- WaveMaker: Low-code platform for creating enterprise web applications.
- App Sketcher: Creates interactive web prototypes using HTML and jQuery. 

### Cross-Platform & Others
- [Qt Creator](): A full IDE that includes a deep visual editor for C++ Qt development.
    * Cross-platform (C++, Python) IDE with a powerful visual editor.
- [wxFormBuilder](): A cross-platform visual designer for wxPython.
    * produces C++, Python, or XML code for native-looking desktop applications. 
- Flet: A framework that lets you build interactive Flutter-based apps in Python, often used with simple layout concepts.
- Lazarus: A professional open-source visual IDE for Rapid Application Development (RAD) using Free Pascal. 

### Embedded & Specialized
- Microsoft Visual Studio: Standard for Windows application development (WPF, WinForms, UWP).
- Embedded Wizard: Optimized for creating GUIs on embedded systems.
- JUCE: Popular for audio and multimedia application development.
- Godot Engine: While a game engine, it is highly capable of creating 2D/3D GUIs and app front-ends.
- Xcode: Official IDE for macOS and iOS app development.
- Lazarus IDE: Open-source Free Pascal RAD IDE, similar to Delphi.
- Xojo: Cross-platform tool for desktop, web, and mobile app creation.

