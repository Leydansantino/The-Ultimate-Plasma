var plasma = getApiVersion(1);

var layout = {
    "desktops": [
        {
            "applets": [],
            "config": {
                "/": {
                    "formfactor": "0",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                },
                "/Wallpaper/org.kde.image/General": {
                    "Image": "/usr/share/wallpapers/Next/contents/images/3840x2160.png",
                    "SlidePaths": "/usr/share/wallpapers/"
                },
                "/Wallpaper/org.kde.potd/General": {
                    "Provider": "flickr"
                }
            },
            "wallpaperPlugin": "org.kde.image"
        },
        {
            "applets": [],
            "config": {
                "/": {
                    "formfactor": "0",
                    "immutability": "1",
                    "lastScreen": "1",
                    "wallpaperplugin": "org.kde.image"
                },
                "/Wallpaper/org.kde.image/General": {
                    "Image": "/usr/share/wallpapers/Next/contents/images/3840x2160.png",
                    "SlidePaths": "/usr/share/wallpapers/"
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
                    "config": {},
                    "plugin": "org.kde.plasma.minimizeall"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.pager"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.panelspacer"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.notifications"
                },
                {
                    "config": {
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
                        }
                    },
                    "plugin": "org.kde.plasma.digitalclock"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.panelspacer"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.colorpicker"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.systemtray"
                }
            ],
            "config": {
                "/": {
                    "formfactor": "2",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                },
                "/General": {
                    "floating": "1",
                    "adaptiveTransparency": "1"
                }
            },
            "height": 32,
            "hiding": "normal",
            "lengthMode": "fill",
            "location": "top",
            "maximumLength": 1920,
            "minimumLength": 1920,
            "offset": 0
        },
        {
            "alignment": "center",
            "applets": [
                {
                    "config": {
                        "/General": {
                            "iconSpacing": "0",
                            "launchers": "preferred://systemsettings,applications:org.kde.konsole.desktop,preferred://filemanager"
                        }
                    },
                    "plugin": "org.kde.plasma.icontasks"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.trash"
                },
                {
                    "config": {
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
                },
                "/General": {
                    "floating": "1"
                }
            },
            "height": 64,
            "hiding": "dodgewindows",
            "lengthMode": "fit",
            "location": "bottom",
            "maximumLength": 1920,
            "minimumLength": 0,
            "offset": 0
        }
    ],
    "serializationFormatVersion": "1"
};

plasma.loadSerializedLayout(layout);
