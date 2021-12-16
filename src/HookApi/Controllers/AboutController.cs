using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace HookApi.Controllers
{
	[ApiController]
	[Route("api/[controller]")]
	public class AboutController : ControllerBase
	{

		private readonly ILogger<AboutController> _logger;

		public AboutController(ILogger<AboutController> logger)
		{
			_logger = logger;
		}

		[HttpGet]
		public ActionResult Get()
		{
			return new JsonResult(new { MyNameIs = "Ali2021" });
		}
	}
}
