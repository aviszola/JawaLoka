package net.sijawa.viewHolder

import android.support.v7.widget.RecyclerView
import android.view.View
import android.widget.ImageView
import net.sijawa.Interface.ItemClickListener
import net.sijawa.R

class LevelThreeViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView), View.OnClickListener {


    var category_image: ImageView

    private var itemClickListener: ItemClickListener? = null

    init {
        category_image = itemView.findViewById(R.id.category_image) as ImageView

        itemView.setOnClickListener(this)
    }

    fun setItemClickListener(itemClickListener: ItemClickListener) {
        this.itemClickListener = itemClickListener
    }

    override fun onClick(view: View) {
        itemClickListener!!.onClick(view, adapterPosition, false)
    }
}