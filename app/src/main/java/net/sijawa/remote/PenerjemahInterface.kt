package net.sijawa.remote

import net.sijawa.model.PenerjemahResponse
import retrofit2.Call
import retrofit2.http.Field
import retrofit2.http.FormUrlEncoded
import retrofit2.http.Headers
import retrofit2.http.POST

interface PenerjemahInterface {
//
//    @Headers(
//        "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.62 Safari/537.36",
//        "Cookie: PHPSESSID=obt0l8put2bm7ishdb7d6bmdj6",
//        "Content-type: application/x-www-form-urlencoded"
//    )

    @FormUrlEncoded
    @POST("translate")
    fun translate(@Field("source")source:String,
                  @Field("from")from:String,
                  @Field("to")to:String): Call<PenerjemahResponse>

}