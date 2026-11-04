package net.sijawa.activity

import android.animation.ArgbEvaluator
import android.content.Context
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v4.view.ViewPager
import android.view.View
import com.tbuonomo.viewpagerdotsindicator.DotsIndicator
import com.tbuonomo.viewpagerdotsindicator.WormDotsIndicator
import net.sijawa.R
import net.sijawa.adapter.VpAdapter
import uk.co.chrisjenx.calligraphy.CalligraphyConfig
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper
import okhttp3.HttpUrl
import retrofit2.Retrofit
import okhttp3.OkHttpClient
import java.util.ArrayList




class PenggunaanBahasaJawaActivity : AppCompatActivity() {
    internal lateinit var viewPager: ViewPager
    internal lateinit var adapter: VpAdapter
    internal lateinit var models: MutableList<net.sijawa.model.ViewPager>
    internal lateinit var dotsIndicator: WormDotsIndicator
    internal var colors: Array<Int>? = null
    internal var argbEvaluator = ArgbEvaluator()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        CalligraphyConfig.initDefault(
            CalligraphyConfig.Builder()
                .setDefaultFontPath("fonts/MontserratAlternates-Bold.otf")
                .setFontAttrId(R.attr.fontPath)
                .build()
        )
        setContentView(R.layout.activity_penggunaan_bahasa_jawa)



        models = ArrayList()
        models.add(
             net.sijawa.model.ViewPager(R.drawable.implementasi_1)
        )
        models.add(
            net.sijawa.model.ViewPager(R.drawable.implementasi_2)
        )
        models.add(
            net.sijawa.model.ViewPager(R.drawable.implementasi_3)
        )

        adapter = VpAdapter(models, this)


        viewPager = findViewById(R.id.viewPager)
        viewPager.adapter = adapter

        dotsIndicator = findViewById(R.id.dots_indicator)
        dotsIndicator.setViewPager(viewPager)





        viewPager.setOnPageChangeListener(object : ViewPager.OnPageChangeListener {
            override fun onPageScrolled(position: Int, positionOffset: Float, positionOffsetPixels: Int) {


            }

            override fun onPageSelected(position: Int) {

            }

            override fun onPageScrollStateChanged(state: Int) {

            }
        })

    }



    override fun attachBaseContext(newBase: Context) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase))
    }



    fun back(v: View?){
        onBackPressed()
    }
}
