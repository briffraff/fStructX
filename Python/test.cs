using System;
using System.IO;
using System.Diagnostics;
using System.Reflection;
using System.Windows.Forms;
using Westwind.Utilities;


namespace MXSPyCOM
{
    class Program
    {
        static void Main()
        {
            bool max_running = is_process_running("3dsmax");
            if (max_running)
            {
                Console.WriteLine("3ds max running..");
            }

            static bool is_process_running(string process_name)
            {
                Process[] pname = Process.GetProcessesByName(process_name);
                if (pname.Length > 0)
                {
                    return true;
                }

                return false;
            }
        }
    }
}
