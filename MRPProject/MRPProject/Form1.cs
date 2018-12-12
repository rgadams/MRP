using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace MRPProject
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void label5_Click(object sender, EventArgs e)
        {

        }

        private void submitButton_Click(object sender, EventArgs e)
        {
            string vendorName = nameText.Text;
            string vendorContact = contactText.Text;
            string vendorPhoneNumber = phoneText.Text;
            string vendorAddress = addressText.Text;
            string vendorCity = cityText.Text;
            string vendorState = stateText.Text;
            string vendorCountry = countryText.Text;
            string vendorPostal = postalText.Text;
            string vendorRating = ratingText.Text;

            String connString = "Data Source=localhost;" +
                "Initial Catalog=MRP;Integrated Security=true;";

            SqlConnection conn = new SqlConnection(connString);

            SqlDataAdapter adapter = new SqlDataAdapter();

            try
            {
                conn.Open();

                String cmdString = "insert into address (StreetAddress, City, State, Country, PostalCode) " +
                    "values (@StreetAddress, @City, @State, @Country, @PostalCode)";

                SqlCommand insertAddressCommand = new SqlCommand(cmdString, conn);
                insertAddressCommand.Parameters.Add(new SqlParameter("StreetAddress", vendorAddress));
                insertAddressCommand.Parameters.Add(new SqlParameter("City", vendorCity));
                insertAddressCommand.Parameters.Add(new SqlParameter("State", vendorState));
                insertAddressCommand.Parameters.Add(new SqlParameter("Country", vendorCountry));
                insertAddressCommand.Parameters.Add(new SqlParameter("PostalCode", vendorPostal));

                adapter.InsertCommand = insertAddressCommand;
                adapter.InsertCommand.ExecuteNonQuery();

                cmdString = "select AddressID from address where StreetAddress = @StreetAddress and City = @City" +
                    " and State = @State and Country = @Country and PostalCode = @PostalCode";

                SqlCommand selectAddressCommand = new SqlCommand(cmdString, conn);
                selectAddressCommand.Parameters.Add(new SqlParameter("StreetAddress", vendorAddress));
                selectAddressCommand.Parameters.Add(new SqlParameter("City", vendorCity));
                selectAddressCommand.Parameters.Add(new SqlParameter("State", vendorState));
                selectAddressCommand.Parameters.Add(new SqlParameter("Country", vendorCountry));
                selectAddressCommand.Parameters.Add(new SqlParameter("PostalCode", vendorPostal));

                DataSet ds = new DataSet();

                adapter.SelectCommand = selectAddressCommand;
                adapter.SelectCommand.ExecuteNonQuery();
                
                adapter.Fill(ds);

                int addressID = Convert.ToInt32(ds.Tables[0].Rows[0].ItemArray[0].ToString());

                cmdString = "insert into vendors (VendorName, ContactPerson, PhoneNumber, VendorAddressID, VendorRating) " +
                    "values (@VendorName, @ContactPerson, @PhoneNumber, @VendorAddressID, @VendorRating)";

                SqlCommand insertVendorCommand = new SqlCommand(cmdString, conn);
                insertVendorCommand.Parameters.Add(new SqlParameter("VendorName", vendorName));
                insertVendorCommand.Parameters.Add(new SqlParameter("ContactPerson", vendorContact));
                insertVendorCommand.Parameters.Add(new SqlParameter("PhoneNumber", vendorPhoneNumber));
                insertVendorCommand.Parameters.Add(new SqlParameter("VendorAddressID", addressID));
                insertVendorCommand.Parameters.Add(new SqlParameter("VendorRating", vendorRating));

                adapter.InsertCommand = insertVendorCommand;
                adapter.InsertCommand.ExecuteNonQuery();

                cmdString = "select VendorID from Vendors where VendorName = @VendorName and ContactPerson = @ContactPerson " +
                    "and PhoneNumber = @PhoneNumber and VendorAddressID = @VendorAddressID and VendorRating = @VendorRating";

                SqlCommand selectVendorCommand = new SqlCommand(cmdString, conn);
                selectVendorCommand.Parameters.Add(new SqlParameter("VendorName", vendorName));
                selectVendorCommand.Parameters.Add(new SqlParameter("ContactPerson", vendorContact));
                selectVendorCommand.Parameters.Add(new SqlParameter("PhoneNumber", vendorPhoneNumber));
                selectVendorCommand.Parameters.Add(new SqlParameter("VendorAddressID", addressID));
                selectVendorCommand.Parameters.Add(new SqlParameter("VendorRating", vendorRating));

                DataSet ds2 = new DataSet();

                adapter.SelectCommand = selectVendorCommand;
                adapter.SelectCommand.ExecuteNonQuery();

                adapter.Fill(ds2);

                int vendorID = Convert.ToInt32(ds2.Tables[0].Rows[0].ItemArray[0].ToString());

                int partID = 0;

                SqlCommand updatePartsCommand;

                foreach (object item in clbParts.CheckedItems)
                {
                    DataRowView rowItem = item as DataRowView;
                    partID = (int) rowItem["PartID"];

                    MessageBox.Show(vendorID.ToString());

                    cmdString = "update parts set VendorID = @VendorID where PartID = @PartID";
                    
                    updatePartsCommand = new SqlCommand(cmdString, conn);
                    updatePartsCommand.Parameters.Add(new SqlParameter("VendorID", vendorID));
                    updatePartsCommand.Parameters.Add(new SqlParameter("PartID", partID));

                    adapter.UpdateCommand = updatePartsCommand;
                    adapter.UpdateCommand.ExecuteNonQuery();
                }
                
                conn.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }


        }

        private void checkedListBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
