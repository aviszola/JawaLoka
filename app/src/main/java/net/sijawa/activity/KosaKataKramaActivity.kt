package net.sijawa.activity

import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.app.AlertDialog
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.text.Editable
import android.text.TextWatcher
import android.view.LayoutInflater
import android.view.View
import android.widget.EditText
import android.widget.Toast
import com.firebase.ui.database.FirebaseRecyclerAdapter
import com.google.firebase.database.*
import kotlinx.android.synthetic.main.activity_peribahasa.*
import kotlinx.android.synthetic.main.dialog.view.*
import kotlinx.android.synthetic.main.item_does.view.*
import net.sijawa.R
import net.sijawa.adapter.KosaKataKramaAdapter
import net.sijawa.adapter.PeribahasaAdapter
import net.sijawa.model.KosaKata
import net.sijawa.model.Peribahasa
import uk.co.chrisjenx.calligraphy.CalligraphyConfig
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper
import java.util.ArrayList

class KosaKataKramaActivity : AppCompatActivity() {

    lateinit var mSearchText : EditText
    lateinit var mRecyclerView : RecyclerView
    internal lateinit var list: ArrayList<KosaKata>
    internal lateinit var kosaKataKramaAdapter: KosaKataKramaAdapter
    lateinit var mDatabase : DatabaseReference


    lateinit var FirebaseRecyclerAdapter : FirebaseRecyclerAdapter<KosaKata, UsersViewHolder>

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        CalligraphyConfig.initDefault(
            CalligraphyConfig.Builder()
                .setDefaultFontPath("fonts/Montserrat-Bold.ttf")
                .setFontAttrId(R.attr.fontPath)
                .build()
        )
        setContentView(R.layout.activity_kosa_kata_krama)

        mSearchText =findViewById(R.id.search)
        mRecyclerView = findViewById(R.id.ourdoes)


        mRecyclerView.setHasFixedSize(true)
        mRecyclerView.layoutManager = LinearLayoutManager(this)
        list = ArrayList<KosaKata>()


        mDatabase = FirebaseDatabase.getInstance().reference.child("KosaKata")
        // get data from firebase

        loadFirst()



        mSearchText.addTextChangedListener(object  : TextWatcher {
            override fun afterTextChanged(p0: Editable?) {


            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                val searchText = mSearchText.getText().toString().trim()
                loadFirebaseData(searchText)

            }
        } )

    }

    private fun loadFirst() {
        val dbSort = mDatabase.orderByChild("inggil")
        dbSort.addValueEventListener(object : ValueEventListener {
            override fun onDataChange(dataSnapshot: DataSnapshot) {
                // set code to retrive data and replace layout
                for (dataSnapshot1 in dataSnapshot.children) {
                    val p = dataSnapshot1.getValue<KosaKata>(KosaKata::class.java)
                    list.add(p!!)
                }
                kosaKataKramaAdapter = KosaKataKramaAdapter(this@KosaKataKramaActivity, list)
                ourdoes.adapter = kosaKataKramaAdapter
                kosaKataKramaAdapter.notifyDataSetChanged()
            }

            override fun onCancelled(databaseError: DatabaseError) {
                // set code to show an error
                Toast.makeText(applicationContext, "No Data", Toast.LENGTH_SHORT).show()
            }
        })
    }

    private fun loadFirebaseData(searchText : String) {
        endpage.visibility = View.INVISIBLE



        if(searchText.isEmpty()){
            FirebaseRecyclerAdapter.cleanup()
            mRecyclerView.adapter = FirebaseRecyclerAdapter
            loadFirst()


        }else {

            val firebaseSearchQuery = mDatabase.orderByChild("inggil").startAt(searchText).endAt(searchText + "\uf8ff")

            FirebaseRecyclerAdapter = object : FirebaseRecyclerAdapter<KosaKata, UsersViewHolder>(

                KosaKata::class.java,
                R.layout.item_does,
                UsersViewHolder::class.java,
                firebaseSearchQuery
            ) {
                override fun populateViewHolder(viewHolder: UsersViewHolder, model: KosaKata?, position: Int) {
                    viewHolder.mview.titledoes.text = model?.inggil

                    val getKrama = model?.inggil
                    val getNgoko = model?.ngoko
                    val getBahasa = model?.bahasa

                    viewHolder.mview.setOnClickListener {
                        val mDialogView = LayoutInflater.from(this@KosaKataKramaActivity).inflate(R.layout.dialog, null)
                        //AlertDialogBuilder
                        val alertDialog = AlertDialog.Builder(this@KosaKataKramaActivity)
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

            }
            mRecyclerView.adapter = FirebaseRecyclerAdapter

        }
    }
    override fun attachBaseContext(newBase: Context) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase))
    }

    fun back(v: View?){
        onBackPressed()
    }

    // // View Holder Class

    class UsersViewHolder(var mview : View) : RecyclerView.ViewHolder(mview) {

    }


}
