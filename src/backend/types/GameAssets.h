// Pegasus Frontend
// Copyright (C) 2017  Mátyás Mustoha
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.


#pragma once

#include "Assets.h"

#include <QString>
#include <QObject>


namespace Types {

class GameAssets : public QObject {
    Q_OBJECT

    // NOTE: by manually listing the properties (instead of eg. a Map),
    //       it is also possible to refer the same data by a different name
    Q_PROPERTY(QString boxFront READ boxFront CONSTANT)
    Q_PROPERTY(QString boxBack READ boxBack CONSTANT)
    Q_PROPERTY(QString boxSpine READ boxSpine CONSTANT)
    Q_PROPERTY(QString boxFull READ boxFull CONSTANT)
    Q_PROPERTY(QString box READ boxFull CONSTANT)
    Q_PROPERTY(QString cartridge READ cartridge CONSTANT)
    Q_PROPERTY(QString logo READ logo CONSTANT)
    Q_PROPERTY(QString marquee READ marquee CONSTANT)
    Q_PROPERTY(QString bezel READ bezel CONSTANT)
    Q_PROPERTY(QString gridicon READ gridicon CONSTANT)
    Q_PROPERTY(QString flyer READ flyer CONSTANT)
    Q_PROPERTY(QString background READ background CONSTANT)
    Q_PROPERTY(QString music READ music CONSTANT)

    // TODO: these could be optimized, see
    // https://doc.qt.io/qt-5/qtqml-cppintegration-data.html (Sequence Type to JavaScript Array)
    Q_PROPERTY(QStringList screenshots READ screenshots CONSTANT)
    Q_PROPERTY(QStringList videos READ videos CONSTANT)

public:
    explicit GameAssets(QObject* parent = nullptr);

    QHash<AssetType, QString> m_single_assets;
    QHash<AssetType, QStringList> m_multi_assets;

    void setSingle(AssetType, QString);
    void appendMulti(AssetType, QString);

    QString boxFront() const { return m_single_assets[AssetType::BOX_FRONT]; }
    QString boxBack() const { return m_single_assets[AssetType::BOX_BACK]; }
    QString boxSpine() const { return m_single_assets[AssetType::BOX_SPINE]; }
    QString boxFull() const { return m_single_assets[AssetType::BOX_FULL]; }
    QString cartridge() const { return m_single_assets[AssetType::CARTRIDGE]; }
    QString logo() const { return m_single_assets[AssetType::LOGO]; }
    QString marquee() const { return m_single_assets[AssetType::MARQUEE]; }
    QString bezel() const { return m_single_assets[AssetType::BEZEL]; }
    QString gridicon() const { return m_single_assets[AssetType::STEAMGRID]; }
    QString flyer() const { return m_single_assets[AssetType::FLYER]; }
    QString background() const { return m_single_assets[AssetType::BACKGROUND]; }
    QString music() const { return m_single_assets[AssetType::MUSIC]; }

    QStringList screenshots() const { return m_multi_assets[AssetType::SCREENSHOTS]; }
    QStringList videos() const { return m_multi_assets[AssetType::VIDEOS]; }
};

} // namespace Types
