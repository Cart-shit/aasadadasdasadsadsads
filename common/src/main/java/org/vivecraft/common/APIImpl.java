package org.vivecraft.common;

import net.minecraft.server.level.ServerPlayer;
import net.minecraft.world.entity.player.Player;
import org.vivecraft.api.CommonNetworkHelper;
import org.vivecraft.api_beta.VivecraftAPI;
import org.vivecraft.client.VRPlayersClient;

public final class APIImpl implements VivecraftAPI {

    public static final APIImpl INSTANCE = new APIImpl();

    private APIImpl() {
    }

    @Override
    public boolean isVRPlayer(Player player) {
        if (player instanceof ServerPlayer serverPlayer) {
            return CommonNetworkHelper.isVRPlayer(serverPlayer);
        }

        return VRPlayersClient.getInstance().isVRPlayer(player);
    }
}
