package net.sijawa.activity

import android.content.Context
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.FrameLayout
import net.sijawa.R
import uk.co.chrisjenx.calligraphy.CalligraphyConfig
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper


class KosakataActivity : AppCompatActivity() {

    lateinit var krama: FrameLayout
    lateinit var ngoko: FrameLayout
    lateinit var bahasa: FrameLayout
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        CalligraphyConfig.initDefault(
            CalligraphyConfig.Builder()
                .setDefaultFontPath("fonts/MontserratAlternates-Bold.otf")
                .setFontAttrId(R.attr.fontPath)
                .build()
        )
        setContentView(R.layout.activity_kosakata)

        krama = findViewById(R.id.kosakata_c1)
        krama.setOnClickListener {
            val a = Intent(this@KosakataActivity, KosaKataKramaActivity::class.java)
            startActivity(a)
        }

        ngoko = findViewById(R.id.kosakata_c2)
        ngoko.setOnClickListener {
            val a = Intent(this@KosakataActivity, KosaKataNgokoActivity::class.java)
            startActivity(a)
        }
        bahasa = findViewById(R.id.kosakata_c3)
        bahasa.setOnClickListener {
            val a = Intent(this@KosakataActivity, KosaKataBahasaActivity::class.java)
            startActivity(a)
        }

    }

    override fun attachBaseContext(newBase: Context) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase))
    }

    fun back(v: View?){
        onBackPressed()
    }
}
