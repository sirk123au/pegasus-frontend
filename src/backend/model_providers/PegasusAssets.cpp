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


#include "PegasusAssets.h"

#include "Utils.h"
#include "types/Collection.h"

#include <QStringBuilder>


namespace model_providers {

void PegasusAssets::fill(const Types::Collection& collection)
{
    for (Types::Game* const game_ptr : qAsConst(collection.gameList().allGames())) {
        Q_ASSERT(game_ptr);
        fillOne(collection, *game_ptr);
    }
}

void PegasusAssets::fillOne(const Types::Collection& collection, Types::Game& game)
{
    Q_ASSERT(!collection.searchDirs().isEmpty());

    constexpr auto MEDIA_SUBDIR = "/media/";

    const QString path_base = collection.searchDirs().first()
                              % MEDIA_SUBDIR
                              % game.m_rom_basename;

    // check if the media dir exists
    if (!validPath(collection.searchDirs().first() % MEDIA_SUBDIR))
        return;

    // shortcut for the assets member
    Types::GameAssets& assets = game.assets();

    for (auto asset_type : Assets::singleTypes) {
        // the portable asset search is always the first,
        // so we don't have to do expensi if checks here
        Q_ASSERT(assets.m_single_assets[asset_type].isEmpty());

        assets.m_single_assets[asset_type] = Assets::findFirst(asset_type, path_base);
    }
    for (auto asset_type : Assets::multiTypes) {
        assets.m_multi_assets[asset_type].append(Assets::findAll(asset_type, path_base));
    }
}

} // namespace model_providers
