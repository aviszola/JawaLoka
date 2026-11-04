package net.sijawa.activity

import android.content.Context
import android.graphics.Typeface
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.widget.Toolbar
import android.view.View
import kotlinx.android.synthetic.main.content_detail_angka.*
import net.sijawa.R
import uk.co.chrisjenx.calligraphy.CalligraphyConfig
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper

class PenggunaanAngkaActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_penggunaan_angka)
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
        contoh1.typeface = MBold
        angka110.typeface = MMedium
        angka_0.typeface = MBold
        angka_1.typeface = MBold
        angka_2.typeface = MBold
        angka_3.typeface = MBold
        angka_4.typeface = MBold
        angka_5.typeface = MBold
        angka_6.typeface = MBold
        angka_7.typeface = MBold
        angka_8.typeface = MBold
        angka_9.typeface = MBold

        contoh2.typeface = MBold
        angka1119.typeface = MMedium
        angka11.typeface = MMedium

        contoh3.typeface = MBold
        angka2029.typeface = MMedium
        angka20.typeface = MMedium

        contoh4.typeface = MBold
        angka5050.typeface = MMedium
        angka50.typeface = MMedium

        contoh5.typeface = MBold
        angka6060.typeface = MMedium
        angka60.typeface = MMedium
    }

    override fun attachBaseContext(newBase: Context) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase))
    }
}

