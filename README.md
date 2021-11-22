<div id="top"></div>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/wekempf/pshape">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">PShape</h3>

  <p align="center">
    A modern PowerShell templating and scaffolding engine!
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template/issues">Report Bug</a>
    ·
    <a href="https://github.com/othneildrew/Best-README-Template/issues">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
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
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://example.com)

PowerShell has a great templating engine already in [Plaster](https://www.powershellgallery.com/packages/Plaster), but I've found it difficult to work with. Scaffolding with `Invoke-Plaster` is difficult, requiring you to specify the full path to the template you want to use. Authoring templates is complicated with a complex XML manifest file and a template syntax that is while very powerful, also not the friendliest to write. Packaging and sharing templates is an after thought at best. I believe that all of these traits lead to `Plaster` not being used as much as a templating engine should be.

`PShape` is a modern PowerShell templating and scaffolding engine designed to address all of these issues. When scaffolding you use a template's name, rather than having to specify a path. Authoring is greatly simplified with a slim manifest file, authored in JSON, with useful default behavior. The template files are authored using [Moustache](https://mustache.github.io/mustache.5.html) a very simple "logic-less" templating syntax. Packaging templates is as simple as creating a PowerShell module (a PShape template exists for that!) with a `PShapes` directory and sharing is as easy as publishing that module to the [PowerShell Gallery](https://www.powershellgallery.com/). My hope is that all of this means there will be plenty of templates contributed by the community, but `PShape` comes with a core set of templates out of the box.

<p align="right">(<a href="#top">back to top</a>)</p>

### Built With

The following build tools are used in the creation of `PShape`, but they are all (with the obvious exception of PowerShell Core 7) bootstrapped by the `build.ps1` script.

Note: As a modern PowerShell templating engine there's currently a requirement for PowerShell Core 7. If you need to use `PShape` on an older PowerShell version I'm taking pull requests. :)

* [PowerShell Core 7](https://github.com/powershell/powershell)
* [InvokeBuild](https://github.com/nightroman/Invoke-Build)
* [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)
* [Pester](https://pester.dev/)
* [GitVersion](https://gitversion.net/)
* [PlatyPS](https://github.com/PowerShell/platyPS)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

`PShape` is very friendly to use and is distributed as a PowerShell module in the [PowerShell Gallery](https://www.powershellgallery.com/).

### Installation

To use `PShape` the first thing you'll need to do is install the module.

```PowerShell
PS> Install-Module PShape -Scope CurrentUser
```

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->
## Usage

If you haven't already done so, you should import the `PShape` module (consider adding this to your profile).

```PowerShell
PS> Import-Module PShape
```

With `PShape` imported you can get a list of the known templates (at this point it's likely only the default templates that come with the `PShape` module).

```PowerShell
PS> Get-PShapeTemplate
```

You can generate files from a template by simply specifying the template name.

```PowerShell
PS> New-PShape -Name script -InputObject @{ name = 'myscript' }
```

You can read a lot more information about using `PShape` by reading `about_PShape`.

```PowerShell
PS> Get-Help about_PShape
```

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- ROADMAP -->
## Roadmap

- [ ] Publish 1.0 package to the PowerShell Gallery

See the [open issues](https://github.com/wekempf/pshape/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Another great way to contribute is to simply create `PShape` templates and publish them to the [PowerShell Gallery](https://www.powershellgallery.com/). See `about_PShape` for more information on how this is done.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the MIT License. See [LICENSE](https://raw.githubusercontent.com/wekempf/pshape/main/LICENSE) for more information.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

William E. Kempf - [@wekempf](https://twitter.com/wekempf) - wekempf@outlook.com

Project Link: [https://github.com/wekempf/pshape](https://github.com/wekempf/pshape)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

Use this space to list resources you find helpful and would like to give credit to. I've included a few of my favorites to kick things off!

* [Plaster](https://github.com/PowerShellOrg/Plaster)
* [Poshstache](https://github.com/baldator/Poshstache)
* [Moustache](https://mustache.github.io/mustache.5.html)
* [InvokeBuild](https://github.com/nightroman/Invoke-Build)
* [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)
* [Pester](https://pester.dev/)
* [GitVersion](https://gitversion.net/)
* [PlatyPS](https://github.com/PowerShell/platyPS)
* [Best-README-Template](https://github.com/othneildrew/Best-README-Template)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/wekempf/pshape?style=for-the-badge
[contributors-url]: https://github.com/wekempf/pshape/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/wekempf/pshape?style=for-the-badge
[forks-url]: https://github.com/wekempf/pshape/network/members
[stars-shield]: https://img.shields.io/github/stars/wekempf/pshape.svg?style=for-the-badge
[stars-url]: https://github.com/wekempf/pshape/stargazers
[issues-shield]: https://img.shields.io/github/issues/wekempf/pshape.svg?style=for-the-badge
[issues-url]: https://github.com/wekempf/pshape/issues
[license-shield]: https://img.shields.io/github/license/wekempf/pshape.svg?style=for-the-badge
[license-url]: https://github.com/wekempf/pshape/blob/master/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/wekempf
[product-screenshot]: images/screenshot.png
