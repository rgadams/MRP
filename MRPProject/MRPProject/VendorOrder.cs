//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace MRPProject
{
    using System;
    using System.Collections.Generic;
    
    public partial class VendorOrder
    {
        public int OrderID { get; set; }
        public int VendorID { get; set; }
        public int ProductID { get; set; }
        public int QuantityOrdered { get; set; }
        public int QuantityReceived { get; set; }
        public System.DateTime OrderDate { get; set; }
        public string OrderStatus { get; set; }
    
        public virtual Part Part { get; set; }
        public virtual Vendor Vendor { get; set; }
    }
}