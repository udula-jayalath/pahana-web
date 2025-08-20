package lk.icbt.pahana.service;

import lk.icbt.pahana.model.ManualSection;
import java.util.ArrayList;
import java.util.List;

public class HelpService {

    public List<ManualSection> getManualSections() {
        List<ManualSection> list = new ArrayList<>();

        list.add(new ManualSection(
                "getting-started", "Getting Started",
                """
                <ol>
                  <li>Open the app and go to <code>/views/login.jsp</code>.</li>
                  <li>Enter your <b>username</b> and <b>password</b>, then click <b>Login</b>.</li>
                  <li>You will be redirected to the <b>Dashboard</b>.</li>
                </ol>
                """
        ));

        list.add(new ManualSection(
                "dashboard", "Dashboard Overview",
                """
                <p>The Dashboard provides quick access to the main modules:</p>
                <ul>
                  <li><b>Customers</b> – manage customer accounts and usage units.</li>
                  <li><b>Items</b> – maintain billable items and unit prices.</li>
                  <li><b>Billing</b> – create invoices, view and print bills.</li>
                </ul>
                """
        ));

        list.add(new ManualSection(
                "customers", "Managing Customers",
                """
                <ol>
                  <li>Go to <b>Customers</b>.</li>
                  <li>Use <b>+ New Customer</b> to add. Fill <i>Account No, Name, Telephone, Units</i>.</li>
                  <li>Use <b>Edit</b> to update; <b>Delete</b> to remove a record.</li>
                  <li>Use the search box to filter by account no or name.</li>
                </ol>
                """
        ));

        list.add(new ManualSection(
                "items", "Managing Items",
                """
                <ol>
                  <li>Go to <b>Items</b>.</li>
                  <li>Add items with <b>+ New Item</b>. Provide <i>Name</i>, <i>Unit Price</i>, <i>Status</i>.</li>
                  <li>Edit or Delete from the list. Search by name.</li>
                </ol>
                """
        ));

        list.add(new ManualSection(
                "billing", "Creating a Bill",
                """
                <ol>
                  <li>Go to <b>Billing</b> → <b>+ New Bill</b>.</li>
                  <li>Select a <b>Customer</b>.</li>
                  <li>Add line items. <i>Unit Price</i> auto-fills; set <i>Qty</i>. <i>Amount = Qty × Unit Price</i>.</li>
                  <li>Optionally set <b>Discount %</b> and <b>Tax %</b>. Totals update live.</li>
                  <li>Click <b>Create Bill</b>. You’ll be redirected to the printable invoice.</li>
                </ol>
                <p><i>Note:</i> The server always uses DB prices when saving — client values are for display only.</p>
                """
        ));

        list.add(new ManualSection(
                "printing", "Viewing & Printing Bills",
                """
                <p>Open the bill and click <b>Print Bill</b>. Buttons/links are hidden in print output.</p>
                """
        ));

        list.add(new ManualSection(
                "troubleshooting", "Troubleshooting",
                """
                <ul>
                  <li><b>Login fails:</b> Check username/password or account status.</li>
                  <li><b>500 error:</b> See Tomcat logs; verify <code>db.properties</code> and DB connectivity.</li>
                  <li><b>JSP compile error:</b> Fix the reported line; redeploy (clean Tomcat <code>work/</code> dir if needed).</li>
                </ul>
                """
        ));

        return list;
    }
}
