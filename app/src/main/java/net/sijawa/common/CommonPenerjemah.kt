package net.sijawa.common

import net.sijawa.remote.PenerjemahInterface
import net.sijawa.remote.RetrofitClient

object CommonPenerjemah {
    val BASE_URL = "http://mongosilakan.net/api/v1/translate/"

    val api: PenerjemahInterface
        get() = RetrofitClient.getClient(BASE_URL).create(PenerjemahInterface::class.java)

}