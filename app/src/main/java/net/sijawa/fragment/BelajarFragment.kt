package net.sijawa.fragment

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.support.v4.app.Fragment
import android.support.v7.widget.CardView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.Toast
import kotlinx.android.synthetic.main.fragment_belajar.*

import net.sijawa.R
import net.sijawa.activity.KosakataActivity
import net.sijawa.activity.PenerjemahActivity
import net.sijawa.activity.PenggunaanBahasaJawaActivity
import net.sijawa.activity.PeribahasaActivity
import uk.co.chrisjenx.calligraphy.CalligraphyConfig

class BelajarFragment : Fragment() {

    lateinit var implementasi: FrameLayout
    lateinit var kosaKata:FrameLayout
    lateinit var peribahasa:FrameLayout
    lateinit var penerjemah:FrameLayout
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val view = inflater.inflate(R.layout.fragment_belajar, container, false)

        implementasi = view.findViewById(R.id.belajar_c1)
        implementasi.setOnClickListener {
            val a = Intent(activity, PenggunaanBahasaJawaActivity::class.java)
            startActivity(a)
        }

        kosaKata = view.findViewById(R.id.belajar_c2)
        kosaKata.setOnClickListener {
            val a = Intent(activity, KosakataActivity::class.java)
            startActivity(a)
        }

        peribahasa = view.findViewById(R.id.belajar_c3)
        peribahasa.setOnClickListener {
            val a = Intent(activity, PenerjemahActivity::class.java)
            startActivity(a)
        }

        penerjemah = view.findViewById(R.id.belajar_c4)
        penerjemah.setOnClickListener {
            val a = Intent(activity, PeribahasaActivity::class.java)
            startActivity(a)
        }

        return view

    }

    companion object {
        fun newInstance(): BelajarFragment {
            val fragment = BelajarFragment()
            val args = Bundle()
            fragment.arguments = args
            return fragment
        }
    }
}