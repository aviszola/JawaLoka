package net.sijawa.activity

import android.content.Context
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.util.Log
import android.view.View
import android.widget.*
import kotlinx.android.synthetic.main.activity_penerjemah.*
import net.sijawa.R
import net.sijawa.common.CommonPenerjemah
import net.sijawa.model.PenerjemahResponse
import net.sijawa.remote.PenerjemahInterface
import uk.co.chrisjenx.calligraphy.CalligraphyConfig
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper





class PenerjemahActivity : AppCompatActivity() {

    internal lateinit var mService: PenerjemahInterface
    internal lateinit var tvHasil: EditText

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        CalligraphyConfig.initDefault(
            CalligraphyConfig.Builder()
                .setDefaultFontPath("fonts/MontserratAlternates-Bold.otf")
                .setFontAttrId(R.attr.fontPath)
                .build()
        )
        setContentView(R.layout.activity_penerjemah)

        mService = CommonPenerjemah.api
        tvHasil = findViewById(R.id.hasil)
        tvHasil.isEnabled=false


        val spinner1: Spinner = findViewById(R.id.from)
        ArrayAdapter.createFromResource(
            this,
            R.array.value,
            android.R.layout.simple_spinner_item
        ).also { adapter ->
            // Specify the layout to use when the list of choices appears
            adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
            // Apply the adapter to the spinner
            spinner1.adapter = adapter
        }
        val spinner2: Spinner = findViewById(R.id.to)
        ArrayAdapter.createFromResource(
            this,
            R.array.value2,
            android.R.layout.simple_spinner_item
        ).also { adapter ->
            // Specify the layout to use when the list of choices appears
            adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
            // Apply the adapter to the spinner
            spinner2.adapter = adapter
        }

        source.addTextChangedListener(object  : TextWatcher {
            override fun afterTextChanged(p0: Editable?) {

            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {

                val etSource = source.text.toString().trim()
                clearTv(etSource)

            }
        } )


        btnTranslate.setOnClickListener {


            val s1 = resources.getStringArray(R.array.key)[spinner1.selectedItemPosition]
            val s2 = resources.getStringArray(R.array.key2)[spinner2.selectedItemPosition]

            when {
                source.text.toString().trim().isEmpty() -> {
                    Toast.makeText(applicationContext, "Tidak Boleh Kosong!", Toast.LENGTH_SHORT).show()
                    source.error = "err"
                }
                else -> postText(source.text.toString(), s1,s2)
            }
        }
    }

    private fun clearTv(etSource: String) {
        if (etSource.isEmpty()){
            tvHasil.text.clear()
        }
    }


    private fun postText(source: String, from: String, to: String) {
        mService.translate(source, from, to)
            .enqueue(object: retrofit2.Callback<PenerjemahResponse> {
                override fun onFailure(call: retrofit2.Call<PenerjemahResponse>, t: Throwable) {
                    Toast.makeText(this@PenerjemahActivity, t.message, Toast.LENGTH_SHORT).show()
                }

                override fun onResponse(call: retrofit2.Call<PenerjemahResponse>, response: retrofit2.Response<PenerjemahResponse>) {
                    val hasil:String = response.body()!!.content!!.model!!.basic!!
                    tvHasil.setText(hasil)
                }
            } )
    }


    override fun attachBaseContext(newBase: Context) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase))
    }

    fun back(v: View?){
        onBackPressed()
    }
}
