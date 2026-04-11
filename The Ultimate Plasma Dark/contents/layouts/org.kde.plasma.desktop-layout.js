var plasma = getApiVersion(1);

var layout = {
    "desktops": [
        {
            "applets": [
            ],
            "config": {
                "/": {
                    "ItemGeometries-1440x900": "",
                    "ItemGeometries-1646x1029": "",
                    "ItemGeometries-1920x1080": "",
                    "ItemGeometriesHorizontal": "",
                    "formfactor": "0",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                },
                "/ConfigDialog": {
                    "DialogHeight": "953",
                    "DialogWidth": "1646"
                },
                "/Wallpaper/org.kde.image/General": {
                    "Image": "/home/leysan/Imágenes/Wallpapers/aurora-borealis-in-mountains-digital-art_3840x2160_xtrafondos.com.jpg",
                    "SlidePaths": "/home/leysan/.local/share/wallpapers/,/usr/share/wallpapers/"
                },
                "/Wallpaper/org.kde.potd/General": {
                    "Provider": "flickr"
                },
                "/Wallpaper/org.kde.slideshow/General": {
                    "SlidePaths": "/home/leysan/Imágenes/Wallpapers/Carrusel/"
                }
            },
            "wallpaperPlugin": "org.kde.image"
        },
        {
            "applets": [
            ],
            "config": {
                "/": {
                    "formfactor": "0",
                    "immutability": "1",
                    "lastScreen": "1",
                    "wallpaperplugin": "org.kde.image"
                },
                "/ConfigDialog": {
                    "DialogHeight": "630",
                    "DialogWidth": "810"
                },
                "/Wallpaper/org.kde.image/General": {
                    "Image": "/home/leysan/Imágenes/Wallpapers/aurora-borealis-in-mountains-digital-art_3840x2160_xtrafondos.com.jpg",
                    "SlidePaths": "/home/leysan/.local/share/wallpapers/,/usr/share/wallpapers/"
                }
            },
            "wallpaperPlugin": "org.kde.image"
        }
    ],
    "panels": [
        {
            "alignment": "center",
            "applets": [
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.minimizeall"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.pager"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.panelspacer"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "513",
                            "popupWidth": "402"
                        }
                    },
                    "plugin": "org.kde.plasma.notifications"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "497",
                            "popupWidth": "554"
                        },
                        "/Appearance": {
                            "autoFontAndSize": "false",
                            "boldText": "true",
                            "customDateFormat": " dddd, d MMMM  ",
                            "dateDisplayFormat": "BesideTime",
                            "dateFormat": "custom",
                            "fontFamily": "Inter",
                            "fontSize": "7",
                            "fontStyleName": "SemiBold",
                            "fontWeight": "600"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        }
                    },
                    "plugin": "org.kde.plasma.digitalclock"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.panelspacer"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "325",
                            "popupWidth": "324"
                        },
                        "/General": {
                            "history": "#ffffff,#eff0f1,#edeeef,#191919,#4154cd,#1f2834,#202d3c,#2f1c25,#3b2831"
                        }
                    },
                    "plugin": "org.kde.plasma.colorpicker"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.systemtray"
                }
            ],
            "config": {
                "/": {
                    "formfactor": "2",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                }
            },
            "height": 2,
            "hiding": "normal",
            "location": "top",
            "maximumLength": 102.875,
            "minimumLength": 102.875,
            "offset": 0
        },
        {
            "alignment": "center",
            "applets": [
                {
                    "config": {
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/General": {
                            "iconSpacing": "0",
                            "launchers": "applications:systemsettings.desktop,applications:org.kde.konsole.desktop,preferred://filemanager,file:///var/lib/flatpak/exports/share/applications/com.brave.Browser.desktop,file:///var/lib/flatpak/exports/share/applications/io.gitlab.librewolf-community.desktop,applications:com.brave.Browser.flextop.brave-cinhimbnkkaeohfgghhklpknlkffjgod-Default.desktop,file:///var/lib/flatpak/exports/share/applications/io.appflowy.AppFlowy.desktop,file:///var/lib/flatpak/exports/share/applications/org.onlyoffice.desktopeditors.desktop,file:///var/lib/flatpak/exports/share/applications/com.valvesoftware.Steam.desktop,file:///var/lib/flatpak/exports/share/applications/io.missioncenter.MissionCenter.desktop,file:///var/lib/flatpak/exports/share/applications/io.github.kolunmi.Bazaar.desktop"
                        }
                    },
                    "plugin": "org.kde.plasma.icontasks"
                },
                {
                    "config": {
                    },
                    "plugin": "org.kde.plasma.trash"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "593",
                            "popupWidth": "686"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/General": {
                            "favoritesPortedToKAstats": "true",
                            "icon": "distributor-logo-white",
                            "systemFavorites": "suspend\\,hibernate\\,reboot\\,shutdown"
                        }
                    },
                    "plugin": "org.kde.plasma.kickoff"
                }
            ],
            "config": {
                "/": {
                    "formfactor": "2",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                }
            },
            "height": 5,
            "hiding": "dodgewindows",
            "location": "bottom",
            "maximumLength": 102.875,
            "minimumLength": 102.875,
            "offset": 0
        }
    ],
    "serializationFormatVersion": "1"
}
;

plasma.loadSerializedLayout(layout);
