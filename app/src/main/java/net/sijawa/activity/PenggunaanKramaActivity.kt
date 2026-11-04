package net.sijawa.activity

import android.content.Context
import android.graphics.Typeface
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.widget.Toolbar
import android.view.View

import kotlinx.android.synthetic.main.content_detail_krama.*
import net.sijawa.R
import uk.co.chrisjenx.calligraphy.CalligraphyConfig
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper

class PenggunaanKramaActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_penggunaan_krama)

        setTypeFace()

        val toolbar = findViewById<Toolbar>(R.id.toolbar)
        setSupportActionBar(toolbar)

        supportActionBar!!.setDisplayHomeAsUpEnabled(true)
        toolbar.setNavigationOnClickListener { onBackPressed() }
    }

    private fun setTypeFace() {
        val MBold = Typeface.createFromAsset(assets, "fonts/Montserrat-Bold.ttf")
        val MMedium = Typeface.createFromAsset(assets, "fonts/Montserrat-Medium.ttf")

        definisi.typeface = MMedium
        krama_2.typeface = MMedium
        contoh1.typeface = MBold
        krama_lugu.typeface = MMedium
        krama_lugu_1.typeface = MBold
        krama_lugu_2.typeface = MBold
        krama_lugu_3.typeface = MBold
        contoh_penggunaan.typeface = MMedium
        contoh_krama_lugu_1.typeface = MBold
        arti_contoh_krama_lugu_1.typeface = MMedium
        contoh_krama_lugu_2.typeface = MBold
        arti_contoh_krama_lugu_2.typeface = MMedium
        contoh_krama_lugu_3.typeface = MBold
        arti_contoh_krama_lugu_3.typeface = MMedium

        contoh2.typeface = MBold
        krama_inggil.typeface = MMedium
        krama_inggil_1.typeface = MBold
        krama_inggil_2.typeface = MBold
        krama_inggil_3.typeface = MBold
        contoh_penggunaan_inggil.typeface = MMedium
        contoh_krama_inggil_1.typeface = MBold
        arti_contoh_krama_inggil_1.typeface = MMedium
        contoh_krama_inggil_2.typeface = MBold
        arti_contoh_krama_inggil_2.typeface = MMedium
        contoh_krama_inggil_3.typeface = MBold
        arti_contoh_krama_inggil_3.typeface = MMedium
    }

}

