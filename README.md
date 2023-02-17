# update_cells_in_lib

<!-- PROJECT LOGO -->
<p align="center">
  <br />
  <a href="https://github.com/EDA-Solutions-Limited/update_cells_in_lib"><strong>Explore the project »</strong></a>
  <br />
  <a href="https://github.com/EDA-Solutions-Limited/update_cells_in_lib/issues">Report Bug</a>
  ·
  <a href="https://github.com/EDA-Solutions-Limited/update_cells_in_lib/issues">Request Feature</a>
</p>

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
        <li><a href="#usage">Usage</a></li>
      </ul>
    </li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About The Project



This script provides a way of force updating every cell in library in a open project. This script was designed as a workaround to a problem experianced by a user where they needed to force a update of all cells in a library.

### Built With

* [Tcl](https://www.tcl.tk/about/language.html)


<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

- L-edit entry tools.

### Installation

1. Download file to a read directory
2. adjust the script global WRITE_LOG to your desired level of logging 0,1,2


#### Persistent
3. adjust line 48 to the desired zoom level
4. for one time use drag and drop the script into S-edit command window, for persistent use copy the script into the '%APPDATA%\Roaming\Tanner EDA\scripts\startup.sedit' folder

#### single use

3. drag and drop the tcl script into the Tcl command window

### Usage

1. In L-edit open a project to run the script on
2. In the L-edit Tcl command window type 
```tcl
update_proj {"<your library name>" "<another library name>"}
 ```

### Notes:
You can also clone the repo:
```sh
git clone https://github.com/EDA-Solutions-Limited/find_net_labels.git
  ```

- The script is set by default to produce a verbose log in the “%APPDATA%\Tanner EDA” under the name “<Tool_name>_debug_<data>_<linux time>”, for example L-Edit_debug_16_02_2023_1676555268394447.txt

- To stop the logging set the global variable WRITE_LOG to 0

<!-- ROADMAP -->
## Roadmap

N/A

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


<!-- LICENSE -->
## License
MIT

<!-- CONTACT -->
## Contact
support@eda-solutions.com
