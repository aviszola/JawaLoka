package net.sijawa.adapter

import android.content.Context
import android.content.Intent
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import net.sijawa.R
import net.sijawa.activity.PeribahasaDetailActivity
import net.sijawa.model.Peribahasa
import java.util.ArrayList

class PeribahasaAdapter(internal var context: Context, internal var myDoes: ArrayList<Peribahasa>) :
    RecyclerView.Adapter<PeribahasaAdapter.MyViewHolder>() {


    override fun onCreateViewHolder(viewGroup: ViewGroup, i: Int): MyViewHolder {
        return MyViewHolder(LayoutInflater.from(context).inflate(R.layout.item_peribahasa, viewGroup, false))
    }

    override fun onBindViewHolder(myViewHolder: MyViewHolder, i: Int) {
        myViewHolder.paribasan.text = myDoes[i].paribasan
       myViewHolder.artiJw.text = myDoes[i].arti_JW
        myViewHolder.artiId.text = myDoes[i].arti_ID

        val getParibasan = myDoes[i].paribasan
        val getArtiId = myDoes[i].arti_ID
        val getArtiJw = myDoes[i].arti_JW


//        myViewHolder.itemView.setOnClickListener {
//            val aa = Intent(context, PeribahasaDetailActivity::class.java)
//            aa.putExtra("paribasan", getParibasan)
//            aa.putExtra("artiId", getArtiId)
//            aa.putExtra("artiJw", getArtiJw)
//            context.startActivity(aa)
//        }
    }

    override fun getItemCount(): Int {
        return myDoes.size
    }

    inner class MyViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        var paribasan: TextView
        var artiJw: TextView
        var artiId: TextView


        init {
            paribasan = itemView.findViewById(R.id.titledoes) as TextView
            artiJw = itemView.findViewById(R.id.titledoess) as TextView
            artiId = itemView.findViewById(R.id.titledoesss) as TextView
        }
    }

}