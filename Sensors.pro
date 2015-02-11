# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = Sensors

CONFIG += sailfishapp

SOURCES += src/Sensors.cpp

OTHER_FILES += qml/Sensors.qml \
    qml/cover/CoverPage.qml \
    rpm/Sensors.changes.in \
    rpm/Sensors.spec \
    rpm/Sensors.yaml \
    translations/*.ts \
    Sensors.desktop \
    qml/pages/accelerometer.qml \
    qml/pages/Mainmenu.qml \
    qml/pages/canvas.qml \
    qml/pages/canvas_settings.qml \
    qml/pages/gyroscope.qml \
    qml/pages/http_ui.qml \
    qml/pages/magnetometer.qml \
    qml/pages/particle.qml \
    qml/pages/particle_settings.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/Sensors-de.ts

RESOURCES += \
    particles.qrc

