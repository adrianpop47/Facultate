using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace lab1
{
    public partial class Form1 : Form
    {
        SqlConnection conn = new SqlConnection("Data Source=DESKTOP-3BDV03E\\SQLEXPRESS;Initial Catalog=Inchisoare;Integrated Security=True");
        SqlDataAdapter da = new SqlDataAdapter();
        DataSet dsc = new DataSet(); //data set celule
        DataSet dsp = new DataSet(); //data set puscariasi

        public Form1()
        {
            InitializeComponent();
        }

        private void connectButton_Click(object sender, EventArgs e)
        {
            da.SelectCommand = new SqlCommand("SELECT * FROM Celule", conn);
            dsc.Clear();
            da.Fill(dsc);
            dataGridView1.DataSource = dsc.Tables[0];
        }

      

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            int rowNumber = dataGridView1.CurrentCell.RowIndex;
            object id = dataGridView1[0, rowNumber].Value;
            int id_c = Int32.Parse(id.ToString());
            try
            {
                conn.Open();
                SqlCommand command = new SqlCommand("SELECT * FROM Detinuti WHERE IdCelula = @id_c;", conn);
                command.Parameters.Add("@id_c", SqlDbType.Int);
                command.Parameters["@id_c"].Value = id_c;
                da.SelectCommand = command;
                dsp.Clear();
                da.Fill(dsp);
                dataGridView2.DataSource = dsp.Tables[0];
                conn.Close();
            }
            catch (Exception ex)
            {
                conn.Close();
                MessageBox.Show(ex.ToString());
            }
        }

        private void insertButton_Click(object sender, EventArgs e)
        {
            try
            {
                int rowNumber = dataGridView1.CurrentCell.RowIndex;
                object id = dataGridView1[0, rowNumber].Value;
                int id_c = Int32.Parse(id.ToString());
                da.InsertCommand = new SqlCommand("INSERT INTO Detinuti (IdCelula, DataIncarcerare, DataEliberare) VALUES(@id,@inc,@eli)", conn);
                da.InsertCommand.Parameters.Add("@id", SqlDbType.Int).Value = Int32.Parse(id_c.ToString());
                da.InsertCommand.Parameters.Add("@inc", SqlDbType.Date).Value = textBox1.Text;
                da.InsertCommand.Parameters.Add("@eli", SqlDbType.Date).Value = textBox2.Text;
                conn.Open();
                da.InsertCommand.ExecuteNonQuery();
                MessageBox.Show("Detinut adaugat cu succes!");
                conn.Close();
                dsp.Clear();
                da.Fill(dsp);
                dataGridView2.DataSource = dsp.Tables[0];
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                conn.Close();
            }
        }

        private void updateButton_Click(object sender, EventArgs e)
        {
            try
            {
                int rowNumber = dataGridView2.CurrentCell.RowIndex;
                object id = dataGridView2[0, rowNumber].Value;
                int id_d = Int32.Parse(id.ToString());
                da.UpdateCommand = new SqlCommand("UPDATE Detinuti SET IdCelula=@idc, DataIncarcerare=@inc, DataEliberare=@eli WHERE IdDetinut=@id", conn);
                da.UpdateCommand.Parameters.Add("@inc", SqlDbType.Date).Value = textBox1.Text;
                da.UpdateCommand.Parameters.Add("@eli", SqlDbType.Date).Value = textBox2.Text;
                da.UpdateCommand.Parameters.Add("@idc", SqlDbType.Int).Value = Int32.Parse(textBox3.Text);
                da.UpdateCommand.Parameters.Add("@id", SqlDbType.Int).Value = Int32.Parse(id_d.ToString());
                conn.Open();
                da.UpdateCommand.ExecuteNonQuery();
                MessageBox.Show("Detinut actualizat cu succes!");
                conn.Close();
                dsp.Clear();
                da.Fill(dsp);
                dataGridView2.DataSource = dsp.Tables[0];
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                conn.Close();
            }
        }

        private void deleteButton_Click(object sender, EventArgs e)
        {
            try
            {
                int rowNumber = dataGridView2.CurrentCell.RowIndex;
                object id = dataGridView2[0, rowNumber].Value;
                int id_d = Int32.Parse(id.ToString());
                da.DeleteCommand = new SqlCommand("DELETE FROM Detinuti WHERE IdDetinut=@id", conn);
                da.DeleteCommand.Parameters.Add("@id", SqlDbType.Int).Value = Int32.Parse(id_d.ToString());
                conn.Open();
                da.DeleteCommand.ExecuteNonQuery();
                MessageBox.Show("Detinut eliminat cu succes!");
                conn.Close();
                dsp.Clear();
                da.Fill(dsp);
                dataGridView2.DataSource = dsp.Tables[0];
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                conn.Close();
            }
        }
    }
}
