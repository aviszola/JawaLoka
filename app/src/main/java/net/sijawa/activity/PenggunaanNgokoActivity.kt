package net.sijawa.activity

import android.content.Context
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.widget.Toolbar
import android.view.View
import net.sijawa.R
import uk.co.chrisjenx.calligraphy.CalligraphyConfig
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper
import android.graphics.Typeface
import kotlinx.android.synthetic.main.content_detail.*


class PenggunaanNgokoActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_penggunaan_ngoko)

        setTypeFace()


        val toolbar = findViewById(R.id.toolbar) as Toolbar
        setSupportActionBar(toolbar)

        supportActionBar!!.setDisplayHomeAsUpEnabled(true)
        toolbar.setNavigationOnClickListener(object : View.OnClickListener {
            override fun onClick(v: View) {
                onBackPressed()
            }
        })

    }

    private fun setTypeFace() {
        val MBold = Typeface.createFromAsset(assets, "fonts/Montserrat-Bold.ttf")
        val MMedium = Typeface.createFromAsset(assets, "fonts/Montserrat-Medium.ttf")

        definisi.typeface = MMedium
        ngoko_2.typeface = MMedium
        contoh1.typeface = MBold
        ngoko_lugu.typeface = MMedium
        ngoko_lugu_1.typeface = MBold
        ngoko_lugu_2.typeface = MBold
        ngoko_lugu_3.typeface = MBold
        contoh_penggunaan.typeface = MMedium
        contoh_ngoko_1.typeface = MBold
        arti_contoh_ngoko_1.typeface = MMedium
        contoh_ngoko_2.typeface = MBold
        arti_contoh_ngoko_2.typeface = MMedium
        contoh_ngoko_3.typeface = MBold
        arti_contoh_ngoko_3.typeface = MMedium


        contoh2.typeface = MBold
        ngoko_alus.typeface = MMedium
        ngoko_alus_1.typeface = MBold
        ngoko_alus_2.typeface = MBold
        ngoko_alus_3.typeface = MBold
        ngoko_alus_4.typeface = MBold
        contoh_penggunaan_alus.typeface = MMedium
        contoh_ngoko_alus_1.typeface = MBold
        arti_contoh_ngoko_alus_1.typeface = MMedium
        contoh_ngoko_alus_2.typeface = MBold
        arti_contoh_ngoko_alus_2.typeface = MMedium
        contoh_ngoko_alus_3.typeface = MBold
        arti_contoh_ngoko_alus_3.typeface = MMedium

    }

    override fun attachBaseContext(newBase: Context) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase))
    }
}
