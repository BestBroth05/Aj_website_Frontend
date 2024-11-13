import 'package:flutter/material.dart';
import 'package:guadalajarav2/extensions/str_extension.dart';
import 'package:guadalajarav2/views/Delivery_Certificate/admin_OC/ChooseCompany.dart';
import 'package:guadalajarav2/views/admin_view/admin_calendar_view/admin_calendar_view.dart';
import 'package:guadalajarav2/views/admin_view/admin_history_view/admin_history_view.dart';
import 'package:guadalajarav2/views/admin_view/admin_projects_view/admin_projects_view.dart';
import 'package:guadalajarav2/views/admin_view/admin_users/admin_users_view.dart';
import 'package:guadalajarav2/views/admin_view/admin_view.dart';
import 'package:guadalajarav2/views/admin_view/aj_cart_view/aj_cart_view.dart';
import 'package:guadalajarav2/views/bom_view/bom_view.dart';
import 'package:guadalajarav2/views/contact_view/contact_container.dart';
import 'package:guadalajarav2/views/dashboard_view/dashboard_view.dart';
import 'package:guadalajarav2/views/error_views/404_view/404.dart';
import 'package:guadalajarav2/views/error_views/not_permitted/not_permitted_view.dart';
import 'package:guadalajarav2/views/inventory_view/inventory_view.dart';
import 'package:guadalajarav2/views/login/loginScreen.dart';
import 'package:guadalajarav2/views/about_view/about_view.dart';
import 'package:guadalajarav2/views/home_screen_view/home_screen_view.dart';
import 'package:guadalajarav2/views/projects_view/projects_view.dart';
import 'package:guadalajarav2/views/services_view/services_view.dart';
import '../views/Quotes/Assemblies/Assemblies.dart';
import '../views/Quotes/Manofacture/Manofacture.dart';
import '../views/Quotes/Proyects/Proyects.dart';
import '../views/Quotes/Quotes.dart';
import '../views/admin_view/admin_Customers/CustomersView.dart';

enum AJRoute {
  home,
  about,
  login,
  bom,
  dashboard,
  inventory,
  contact,
  privacy,
  projects,
  admin,
  services,
  software,
  hardware,
  firmware,
  industrial,
  manufacture,
  adminCart,
  adminProjects,
  adminUsers,
  adminHistory,
  adminCalendar,
  adminDeliverCertificate,
  adminQuotes,
  assemblies,
  proyects,
  manofacture,
  adminAddCustomers,
  notFound,
  notPermitted,
}

extension AJRouteExt on AJRoute {
  String get name {
    switch (this) {
      case AJRoute.login:
        return 'log in';
      default:
        return this.toString().split('.')[1];
    }
  }

  String get url {
    switch (this) {
      case AJRoute.home:
        return '';
      case AJRoute.adminCart:
      case AJRoute.adminProjects:
      case AJRoute.adminUsers:
      case AJRoute.adminHistory:
      case AJRoute.adminCalendar:
        return 'Admin/${name.replaceAll("admin", "")}';
      case AJRoute.adminDeliverCertificate:
      case AJRoute.adminQuotes:
      case AJRoute.assemblies:
      case AJRoute.proyects:
      case AJRoute.manofacture:
      case AJRoute.software:
      case AJRoute.hardware:
      case AJRoute.firmware:
      case AJRoute.industrial:
      case AJRoute.manufacture:
        return 'Services_$name';
      case AJRoute.notFound:
        return '404';
      case AJRoute.notPermitted:
        return 'Invalid';
      default:
        return this.toString().split('.')[1].toTitle();
    }
  }

  Widget get view {
    switch (this) {
      case AJRoute.home:
        return HomeScreenView();
      case AJRoute.about:
        return AboutView();
      case AJRoute.login:
        return LoginScreen();
      case AJRoute.bom:
        return BomView();
      case AJRoute.dashboard:
        return DashBoardView();
      case AJRoute.inventory:
        return InventoryView();
      case AJRoute.admin:
        return AdminView();
      case AJRoute.adminCart:
        return AJCartView();
      case AJRoute.adminProjects:
        return AdminProjectsView();
      case AJRoute.adminUsers:
        return AdminUsersView();
      case AJRoute.adminHistory:
        return AdminHistoryView();
      case AJRoute.adminCalendar:
        return AdminCalendarView();
      case AJRoute.adminDeliverCertificate:
        return ChooseCompany();
      case AJRoute.adminQuotes:
        return CotizacionesHome();
      case AJRoute.assemblies:
        return Assemblies();
      case AJRoute.proyects:
        return Manofacture();
      case AJRoute.manofacture:
        return Projects();
      case AJRoute.adminAddCustomers:
        return CustomersView();
      case AJRoute.services:
        return ServicesView(AJRoute.hardware);
      case AJRoute.software:
      case AJRoute.hardware:
      case AJRoute.firmware:
      case AJRoute.industrial:
      case AJRoute.manufacture:
        return ServicesView(this);
      case AJRoute.contact:
        return ContactContainer();
      case AJRoute.projects:
        return ProjectsView();
      case AJRoute.notFound:
        return PageNotFoundView();
      case AJRoute.notPermitted:
        return PageNotPermittedView();

      default:
        return HomeScreenView();
    }
  }
}
