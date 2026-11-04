package net.sijawa.adapter

import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.support.v7.app.AlertDialog
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import kotlinx.android.synthetic.main.dialog.view.*
import net.sijawa.R
import net.sijawa.activity.KosaKataKramaDetailActivity
import net.sijawa.activity.KosaKataNgokoDetailActivity
import net.sijawa.model.KosaKata
import java.util.ArrayList

class KosaKataNgokoAdapter(internal var context: Context, internal var myDoes: ArrayList<KosaKata>) :
    RecyclerView.Adapter<KosaKataNgokoAdapter.MyViewHolder>() {


    override fun onCreateViewHolder(viewGroup: ViewGroup, i: Int): MyViewHolder {
        return MyViewHolder(LayoutInflater.from(context).inflate(R.layout.item_does, viewGroup, false))
    }

    override fun onBindViewHolder(myViewHolder: MyViewHolder, i: Int) {
        myViewHolder.ngoko.text = myDoes[i].ngoko

        val getKrama = myDoes[i].inggil
        val getNgoko = myDoes[i].ngoko
        val getBahasa = myDoes[i].bahasa


        myViewHolder.itemView.setOnClickListener {
            val mDialogView = LayoutInflater.from(this.context).inflate(R.layout.dialog, null)
            //AlertDialogBuilder
            val alertDialog = AlertDialog.Builder(context)
                .setView(mDialogView)
            alertDialog.setTitle("Arti")
            mDialogView.valuebahasa.text = getBahasa
            mDialogView.valuekrama.text = getKrama
            mDialogView.valuengoko.text = getNgoko
            alertDialog.setPositiveButton("Kembali",
                DialogInterface.OnClickListener { dialog, which -> dialog.cancel() })

            val dialog = alertDialog.create()
            dialog.show()
        }
    }

    override fun getItemCount(): Int {
        return myDoes.size
    }

    inner class MyViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        var ngoko: TextView


        init {
            ngoko = itemView.findViewById(R.id.titledoes) as TextView
        }
    }

}
