using IMS_Setup_App.Services;
using IMS_Setup_App.Views;
using System;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace IMS_Setup_App
{
    public partial class App : Application
    {

        public App()
        {
            InitializeComponent();

            DependencyService.Register<MockDataStore>();
            MainPage = new AppShell();
        }

        protected override void OnStart()
        {
        }

        protected override void OnSleep()
        {
        }

        protected override void OnResume()
        {
        }
    }
}
