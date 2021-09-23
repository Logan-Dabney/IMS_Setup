using IMS_Setup_App.ViewModels;
using System.ComponentModel;
using Xamarin.Forms;

namespace IMS_Setup_App.Views
{
    public partial class ItemDetailPage : ContentPage
    {
        public ItemDetailPage()
        {
            InitializeComponent();
            BindingContext = new ItemDetailViewModel();
        }
    }
}