# Class Hierarchy

This inheritance list is sorted roughly, but not completely, alphabetically:


* **class** [**opae::fpga::types::error**](classopae_1_1fpga_1_1types_1_1error.md) _An error object represents an error register for a resource._ 
* **class** [**opae::fpga::types::event**](classopae_1_1fpga_1_1types_1_1event.md) _Wraps fpga event routines in OPAE C._ 
* **class** [**opae::fpga::types::handle**](classopae_1_1fpga_1_1types_1_1handle.md) _An allocated accelerator resource._ 
* **class** [**opae::fpga::types::properties**](classopae_1_1fpga_1_1types_1_1properties.md) _Wraps an OPAE fpga\_properties object._ 
* **class** [**opae::fpga::types::shared\_buffer**](classopae_1_1fpga_1_1types_1_1shared__buffer.md) _Host/AFU shared memory blocks._ 
* **class** [**opae::fpga::types::src\_location**](classopae_1_1fpga_1_1types_1_1src__location.md) _Identify a particular line in a source file._ 
* **class** [**opae::fpga::types::sysobject**](classopae_1_1fpga_1_1types_1_1sysobject.md) _Wraps the OPAE fpga\_object primitive._ 
* **class** [**opae::fpga::types::token**](classopae_1_1fpga_1_1types_1_1token.md) _Wraps the OPAE fpga\_token primitive._ 
* **class** [**opae::fpga::types::version**](classopae_1_1fpga_1_1types_1_1version.md) 
* **struct** [**\_fpga\_token\_header**](struct__fpga__token__header.md) _Internal token type header._ 
* **struct** [**\_opae\_hash\_map**](struct__opae__hash__map.md) _Hash map object._ 
* **struct** [**\_opae\_hash\_map\_item**](struct__opae__hash__map__item.md) _List link item._ 
* **struct** [**cache\_line**](structcache__line.md) 
* **struct** [**config**](structconfig.md) 
* **struct** [**fpga\_error\_info**](structfpga__error__info.md) 
* **struct** [**fpga\_metric**](structfpga__metric.md) _Metric struct._ 
* **struct** [**fpga\_metric\_info**](structfpga__metric__info.md) _Metric info struct._ 
* **struct** [**fpga\_version**](structfpga__version.md) _Semantic version._ 
* **struct** [**mem\_alloc**](structmem__alloc.md) 
* **struct** [**mem\_link**](structmem__link.md) _Provides an API for allocating/freeing a logical address space._ 
* **struct** [**metric\_threshold**](structmetric__threshold.md) 
* **struct** [**opae::fpga::types::event::type\_t**](structopae_1_1fpga_1_1types_1_1event_1_1type__t.md) _C++ struct that is interchangeable with fpga\_event\_type enum._ 
* **struct** [**opae::fpga::types::guid\_t**](structopae_1_1fpga_1_1types_1_1guid__t.md) _Representation of the guid member of a properties object._ 
* **struct** [**opae::fpga::types::pvalue**](structopae_1_1fpga_1_1types_1_1pvalue.md) _Wraps OPAE properties defined in the OPAE C API by associating an_ `fpga_properties` _reference with the getters and setters defined for a property._
* **struct** [**opae\_uio**](structopae__uio.md) _OPAE UIO device abstraction._ 
* **struct** [**opae\_uio\_device\_region**](structopae__uio__device__region.md) _MMIO region info._ 
* **struct** [**opae\_vfio**](structopae__vfio.md) _OPAE VFIO device abstraction._ 
* **struct** [**opae\_vfio\_buffer**](structopae__vfio__buffer.md) _System DMA buffer._ 
* **struct** [**opae\_vfio\_device**](structopae__vfio__device.md) _VFIO device._ 
* **struct** [**opae\_vfio\_device\_irq**](structopae__vfio__device__irq.md) _Interrupt info._ 
* **struct** [**opae\_vfio\_device\_region**](structopae__vfio__device__region.md) _MMIO region info._ 
* **struct** [**opae\_vfio\_group**](structopae__vfio__group.md) _VFIO group._ 
* **struct** [**opae\_vfio\_iova\_range**](structopae__vfio__iova__range.md) _IO Virtual Address Range._ 
* **struct** [**opae\_vfio\_sparse\_info**](structopae__vfio__sparse__info.md) _MMIO sparse-mappable region info._ 
* **struct** [**ras\_inject\_error**](structras__inject__error.md) 
* **struct** [**threshold**](structthreshold.md) _Threshold struct._ 
* **class** **std::exception**  
  * **class** [**opae::fpga::types::except**](classopae_1_1fpga_1_1types_1_1except.md) _Generic OPAE exception._   
    * **class** [**opae::fpga::types::busy**](classopae_1_1fpga_1_1types_1_1busy.md) _busy exception_ 
    * **class** [**opae::fpga::types::exception**](classopae_1_1fpga_1_1types_1_1exception.md) _exception exception_ 
    * **class** [**opae::fpga::types::invalid\_param**](classopae_1_1fpga_1_1types_1_1invalid__param.md) [_**invalid\_param**_](classopae_1_1fpga_1_1types_1_1invalid__param.md) _exception_
    * **class** [**opae::fpga::types::no\_access**](classopae_1_1fpga_1_1types_1_1no__access.md) [_**no\_access**_](classopae_1_1fpga_1_1types_1_1no__access.md) _exception_
    * **class** [**opae::fpga::types::no\_daemon**](classopae_1_1fpga_1_1types_1_1no__daemon.md) [_**no\_daemon**_](classopae_1_1fpga_1_1types_1_1no__daemon.md) _exception_
    * **class** [**opae::fpga::types::no\_driver**](classopae_1_1fpga_1_1types_1_1no__driver.md) [_**no\_driver**_](classopae_1_1fpga_1_1types_1_1no__driver.md) _exception_
    * **class** [**opae::fpga::types::no\_memory**](classopae_1_1fpga_1_1types_1_1no__memory.md) [_**no\_memory**_](classopae_1_1fpga_1_1types_1_1no__memory.md) _exception_
    * **class** [**opae::fpga::types::not\_found**](classopae_1_1fpga_1_1types_1_1not__found.md) [_**not\_found**_](classopae_1_1fpga_1_1types_1_1not__found.md) _exception_
    * **class** [**opae::fpga::types::not\_supported**](classopae_1_1fpga_1_1types_1_1not__supported.md) [_**not\_supported**_](classopae_1_1fpga_1_1types_1_1not__supported.md) _exception_
    * **class** [**opae::fpga::types::reconf\_error**](classopae_1_1fpga_1_1types_1_1reconf__error.md) [_**reconf\_error**_](classopae_1_1fpga_1_1types_1_1reconf__error.md) _exception_
  * **class** [**opae::fpga::types::except**](classopae_1_1fpga_1_1types_1_1except.md) _Generic OPAE exception._   
    * **class** [**opae::fpga::types::busy**](classopae_1_1fpga_1_1types_1_1busy.md) _busy exception_ 
    * **class** [**opae::fpga::types::exception**](classopae_1_1fpga_1_1types_1_1exception.md) _exception exception_ 
    * **class** [**opae::fpga::types::invalid\_param**](classopae_1_1fpga_1_1types_1_1invalid__param.md) [_**invalid\_param**_](classopae_1_1fpga_1_1types_1_1invalid__param.md) _exception_
    * **class** [**opae::fpga::types::no\_access**](classopae_1_1fpga_1_1types_1_1no__access.md) [_**no\_access**_](classopae_1_1fpga_1_1types_1_1no__access.md) _exception_
    * **class** [**opae::fpga::types::no\_daemon**](classopae_1_1fpga_1_1types_1_1no__daemon.md) [_**no\_daemon**_](classopae_1_1fpga_1_1types_1_1no__daemon.md) _exception_
    * **class** [**opae::fpga::types::no\_driver**](classopae_1_1fpga_1_1types_1_1no__driver.md) [_**no\_driver**_](classopae_1_1fpga_1_1types_1_1no__driver.md) _exception_
    * **class** [**opae::fpga::types::no\_memory**](classopae_1_1fpga_1_1types_1_1no__memory.md) [_**no\_memory**_](classopae_1_1fpga_1_1types_1_1no__memory.md) _exception_
    * **class** [**opae::fpga::types::not\_found**](classopae_1_1fpga_1_1types_1_1not__found.md) [_**not\_found**_](classopae_1_1fpga_1_1types_1_1not__found.md) _exception_
    * **class** [**opae::fpga::types::not\_supported**](classopae_1_1fpga_1_1types_1_1not__supported.md) [_**not\_supported**_](classopae_1_1fpga_1_1types_1_1not__supported.md) _exception_
    * **class** [**opae::fpga::types::reconf\_error**](classopae_1_1fpga_1_1types_1_1reconf__error.md) [_**reconf\_error**_](classopae_1_1fpga_1_1types_1_1reconf__error.md) _exception_
  * **class** [**opae::fpga::types::except**](classopae_1_1fpga_1_1types_1_1except.md) _Generic OPAE exception._   
    * **class** [**opae::fpga::types::busy**](classopae_1_1fpga_1_1types_1_1busy.md) _busy exception_ 
    * **class** [**opae::fpga::types::exception**](classopae_1_1fpga_1_1types_1_1exception.md) _exception exception_ 
    * **class** [**opae::fpga::types::invalid\_param**](classopae_1_1fpga_1_1types_1_1invalid__param.md) [_**invalid\_param**_](classopae_1_1fpga_1_1types_1_1invalid__param.md) _exception_
    * **class** [**opae::fpga::types::no\_access**](classopae_1_1fpga_1_1types_1_1no__access.md) [_**no\_access**_](classopae_1_1fpga_1_1types_1_1no__access.md) _exception_
    * **class** [**opae::fpga::types::no\_daemon**](classopae_1_1fpga_1_1types_1_1no__daemon.md) [_**no\_daemon**_](classopae_1_1fpga_1_1types_1_1no__daemon.md) _exception_
    * **class** [**opae::fpga::types::no\_driver**](classopae_1_1fpga_1_1types_1_1no__driver.md) [_**no\_driver**_](classopae_1_1fpga_1_1types_1_1no__driver.md) _exception_
    * **class** [**opae::fpga::types::no\_memory**](classopae_1_1fpga_1_1types_1_1no__memory.md) [_**no\_memory**_](classopae_1_1fpga_1_1types_1_1no__memory.md) _exception_
    * **class** [**opae::fpga::types::not\_found**](classopae_1_1fpga_1_1types_1_1not__found.md) [_**not\_found**_](classopae_1_1fpga_1_1types_1_1not__found.md) _exception_
    * **class** [**opae::fpga::types::not\_supported**](classopae_1_1fpga_1_1types_1_1not__supported.md) [_**not\_supported**_](classopae_1_1fpga_1_1types_1_1not__supported.md) _exception_
    * **class** [**opae::fpga::types::reconf\_error**](classopae_1_1fpga_1_1types_1_1reconf__error.md) [_**reconf\_error**_](classopae_1_1fpga_1_1types_1_1reconf__error.md) _exception_
  * **class** [**opae::fpga::types::except**](classopae_1_1fpga_1_1types_1_1except.md) _Generic OPAE exception._   
    * **class** [**opae::fpga::types::busy**](classopae_1_1fpga_1_1types_1_1busy.md) _busy exception_ 
    * **class** [**opae::fpga::types::exception**](classopae_1_1fpga_1_1types_1_1exception.md) _exception exception_ 
    * **class** [**opae::fpga::types::invalid\_param**](classopae_1_1fpga_1_1types_1_1invalid__param.md) [_**invalid\_param**_](classopae_1_1fpga_1_1types_1_1invalid__param.md) _exception_
    * **class** [**opae::fpga::types::no\_access**](classopae_1_1fpga_1_1types_1_1no__access.md) [_**no\_access**_](classopae_1_1fpga_1_1types_1_1no__access.md) _exception_
    * **class** [**opae::fpga::types::no\_daemon**](classopae_1_1fpga_1_1types_1_1no__daemon.md) [_**no\_daemon**_](classopae_1_1fpga_1_1types_1_1no__daemon.md) _exception_
    * **class** [**opae::fpga::types::no\_driver**](classopae_1_1fpga_1_1types_1_1no__driver.md) [_**no\_driver**_](classopae_1_1fpga_1_1types_1_1no__driver.md) _exception_
    * **class** [**opae::fpga::types::no\_memory**](classopae_1_1fpga_1_1types_1_1no__memory.md) [_**no\_memory**_](classopae_1_1fpga_1_1types_1_1no__memory.md) _exception_
    * **class** [**opae::fpga::types::not\_found**](classopae_1_1fpga_1_1types_1_1not__found.md) [_**not\_found**_](classopae_1_1fpga_1_1types_1_1not__found.md) _exception_
    * **class** [**opae::fpga::types::not\_supported**](classopae_1_1fpga_1_1types_1_1not__supported.md) [_**not\_supported**_](classopae_1_1fpga_1_1types_1_1not__supported.md) _exception_
    * **class** [**opae::fpga::types::reconf\_error**](classopae_1_1fpga_1_1types_1_1reconf__error.md) [_**reconf\_error**_](classopae_1_1fpga_1_1types_1_1reconf__error.md) _exception_
  * **class** [**opae::fpga::types::except**](classopae_1_1fpga_1_1types_1_1except.md) _Generic OPAE exception._   
    * **class** [**opae::fpga::types::busy**](classopae_1_1fpga_1_1types_1_1busy.md) _busy exception_ 
    * **class** [**opae::fpga::types::exception**](classopae_1_1fpga_1_1types_1_1exception.md) _exception exception_ 
    * **class** [**opae::fpga::types::invalid\_param**](classopae_1_1fpga_1_1types_1_1invalid__param.md) [_**invalid\_param**_](classopae_1_1fpga_1_1types_1_1invalid__param.md) _exception_
    * **class** [**opae::fpga::types::no\_access**](classopae_1_1fpga_1_1types_1_1no__access.md) [_**no\_access**_](classopae_1_1fpga_1_1types_1_1no__access.md) _exception_
    * **class** [**opae::fpga::types::no\_daemon**](classopae_1_1fpga_1_1types_1_1no__daemon.md) [_**no\_daemon**_](classopae_1_1fpga_1_1types_1_1no__daemon.md) _exception_
    * **class** [**opae::fpga::types::no\_driver**](classopae_1_1fpga_1_1types_1_1no__driver.md) [_**no\_driver**_](classopae_1_1fpga_1_1types_1_1no__driver.md) _exception_
    * **class** [**opae::fpga::types::no\_memory**](classopae_1_1fpga_1_1types_1_1no__memory.md) [_**no\_memory**_](classopae_1_1fpga_1_1types_1_1no__memory.md) _exception_
    * **class** [**opae::fpga::types::not\_found**](classopae_1_1fpga_1_1types_1_1not__found.md) [_**not\_found**_](classopae_1_1fpga_1_1types_1_1not__found.md) _exception_
    * **class** [**opae::fpga::types::not\_supported**](classopae_1_1fpga_1_1types_1_1not__supported.md) [_**not\_supported**_](classopae_1_1fpga_1_1types_1_1not__supported.md) _exception_
    * **class** [**opae::fpga::types::reconf\_error**](classopae_1_1fpga_1_1types_1_1reconf__error.md) [_**reconf\_error**_](classopae_1_1fpga_1_1types_1_1reconf__error.md) _exception_
  * **class** [**opae::fpga::types::except**](classopae_1_1fpga_1_1types_1_1except.md) _Generic OPAE exception._   
    * **class** [**opae::fpga::types::busy**](classopae_1_1fpga_1_1types_1_1busy.md) _busy exception_ 
    * **class** [**opae::fpga::types::exception**](classopae_1_1fpga_1_1types_1_1exception.md) _exception exception_ 
    * **class** [**opae::fpga::types::invalid\_param**](classopae_1_1fpga_1_1types_1_1invalid__param.md) [_**invalid\_param**_](classopae_1_1fpga_1_1types_1_1invalid__param.md) _exception_
    * **class** [**opae::fpga::types::no\_access**](classopae_1_1fpga_1_1types_1_1no__access.md) [_**no\_access**_](classopae_1_1fpga_1_1types_1_1no__access.md) _exception_
    * **class** [**opae::fpga::types::no\_daemon**](classopae_1_1fpga_1_1types_1_1no__daemon.md) [_**no\_daemon**_](classopae_1_1fpga_1_1types_1_1no__daemon.md) _exception_
    * **class** [**opae::fpga::types::no\_driver**](classopae_1_1fpga_1_1types_1_1no__driver.md) [_**no\_driver**_](classopae_1_1fpga_1_1types_1_1no__driver.md) _exception_
    * **class** [**opae::fpga::types::no\_memory**](classopae_1_1fpga_1_1types_1_1no__memory.md) [_**no\_memory**_](classopae_1_1fpga_1_1types_1_1no__memory.md) _exception_
    * **class** [**opae::fpga::types::not\_found**](classopae_1_1fpga_1_1types_1_1not__found.md) [_**not\_found**_](classopae_1_1fpga_1_1types_1_1not__found.md) _exception_
    * **class** [**opae::fpga::types::not\_supported**](classopae_1_1fpga_1_1types_1_1not__supported.md) [_**not\_supported**_](classopae_1_1fpga_1_1types_1_1not__supported.md) _exception_
    * **class** [**opae::fpga::types::reconf\_error**](classopae_1_1fpga_1_1types_1_1reconf__error.md) [_**reconf\_error**_](classopae_1_1fpga_1_1types_1_1reconf__error.md) _exception_
  * **class** [**opae::fpga::types::except**](classopae_1_1fpga_1_1types_1_1except.md) _Generic OPAE exception._   
    * **class** [**opae::fpga::types::busy**](classopae_1_1fpga_1_1types_1_1busy.md) _busy exception_ 
    * **class** [**opae::fpga::types::exception**](classopae_1_1fpga_1_1types_1_1exception.md) _exception exception_ 
    * **class** [**opae::fpga::types::invalid\_param**](classopae_1_1fpga_1_1types_1_1invalid__param.md) [_**invalid\_param**_](classopae_1_1fpga_1_1types_1_1invalid__param.md) _exception_
    * **class** [**opae::fpga::types::no\_access**](classopae_1_1fpga_1_1types_1_1no__access.md) [_**no\_access**_](classopae_1_1fpga_1_1types_1_1no__access.md) _exception_
    * **class** [**opae::fpga::types::no\_daemon**](classopae_1_1fpga_1_1types_1_1no__daemon.md) [_**no\_daemon**_](classopae_1_1fpga_1_1types_1_1no__daemon.md) _exception_
    * **class** [**opae::fpga::types::no\_driver**](classopae_1_1fpga_1_1types_1_1no__driver.md) [_**no\_driver**_](classopae_1_1fpga_1_1types_1_1no__driver.md) _exception_
    * **class** [**opae::fpga::types::no\_memory**](classopae_1_1fpga_1_1types_1_1no__memory.md) [_**no\_memory**_](classopae_1_1fpga_1_1types_1_1no__memory.md) _exception_
    * **class** [**opae::fpga::types::not\_found**](classopae_1_1fpga_1_1types_1_1not__found.md) [_**not\_found**_](classopae_1_1fpga_1_1types_1_1not__found.md) _exception_
    * **class** [**opae::fpga::types::not\_supported**](classopae_1_1fpga_1_1types_1_1not__supported.md) [_**not\_supported**_](classopae_1_1fpga_1_1types_1_1not__supported.md) _exception_
    * **class** [**opae::fpga::types::reconf\_error**](classopae_1_1fpga_1_1types_1_1reconf__error.md) [_**reconf\_error**_](classopae_1_1fpga_1_1types_1_1reconf__error.md) _exception_
  * **class** [**opae::fpga::types::except**](classopae_1_1fpga_1_1types_1_1except.md) _Generic OPAE exception._   
    * **class** [**opae::fpga::types::busy**](classopae_1_1fpga_1_1types_1_1busy.md) _busy exception_ 
    * **class** [**opae::fpga::types::exception**](classopae_1_1fpga_1_1types_1_1exception.md) _exception exception_ 
    * **class** [**opae::fpga::types::invalid\_param**](classopae_1_1fpga_1_1types_1_1invalid__param.md) [_**invalid\_param**_](classopae_1_1fpga_1_1types_1_1invalid__param.md) _exception_
    * **class** [**opae::fpga::types::no\_access**](classopae_1_1fpga_1_1types_1_1no__access.md) [_**no\_access**_](classopae_1_1fpga_1_1types_1_1no__access.md) _exception_
    * **class** [**opae::fpga::types::no\_daemon**](classopae_1_1fpga_1_1types_1_1no__daemon.md) [_**no\_daemon**_](classopae_1_1fpga_1_1types_1_1no__daemon.md) _exception_
    * **class** [**opae::fpga::types::no\_driver**](classopae_1_1fpga_1_1types_1_1no__driver.md) [_**no\_driver**_](classopae_1_1fpga_1_1types_1_1no__driver.md) _exception_
    * **class** [**opae::fpga::types::no\_memory**](classopae_1_1fpga_1_1types_1_1no__memory.md) [_**no\_memory**_](classopae_1_1fpga_1_1types_1_1no__memory.md) _exception_
    * **class** [**opae::fpga::types::not\_found**](classopae_1_1fpga_1_1types_1_1not__found.md) [_**not\_found**_](classopae_1_1fpga_1_1types_1_1not__found.md) _exception_
    * **class** [**opae::fpga::types::not\_supported**](classopae_1_1fpga_1_1types_1_1not__supported.md) [_**not\_supported**_](classopae_1_1fpga_1_1types_1_1not__supported.md) _exception_
    * **class** [**opae::fpga::types::reconf\_error**](classopae_1_1fpga_1_1types_1_1reconf__error.md) [_**reconf\_error**_](classopae_1_1fpga_1_1types_1_1reconf__error.md) _exception_
  * **class** [**opae::fpga::types::except**](classopae_1_1fpga_1_1types_1_1except.md) _Generic OPAE exception._   
    * **class** [**opae::fpga::types::busy**](classopae_1_1fpga_1_1types_1_1busy.md) _busy exception_ 
    * **class** [**opae::fpga::types::exception**](classopae_1_1fpga_1_1types_1_1exception.md) _exception exception_ 
    * **class** [**opae::fpga::types::invalid\_param**](classopae_1_1fpga_1_1types_1_1invalid__param.md) [_**invalid\_param**_](classopae_1_1fpga_1_1types_1_1invalid__param.md) _exception_
    * **class** [**opae::fpga::types::no\_access**](classopae_1_1fpga_1_1types_1_1no__access.md) [_**no\_access**_](classopae_1_1fpga_1_1types_1_1no__access.md) _exception_
    * **class** [**opae::fpga::types::no\_daemon**](classopae_1_1fpga_1_1types_1_1no__daemon.md) [_**no\_daemon**_](classopae_1_1fpga_1_1types_1_1no__daemon.md) _exception_
    * **class** [**opae::fpga::types::no\_driver**](classopae_1_1fpga_1_1types_1_1no__driver.md) [_**no\_driver**_](classopae_1_1fpga_1_1types_1_1no__driver.md) _exception_
    * **class** [**opae::fpga::types::no\_memory**](classopae_1_1fpga_1_1types_1_1no__memory.md) [_**no\_memory**_](classopae_1_1fpga_1_1types_1_1no__memory.md) _exception_
    * **class** [**opae::fpga::types::not\_found**](classopae_1_1fpga_1_1types_1_1not__found.md) [_**not\_found**_](classopae_1_1fpga_1_1types_1_1not__found.md) _exception_
    * **class** [**opae::fpga::types::not\_supported**](classopae_1_1fpga_1_1types_1_1not__supported.md) [_**not\_supported**_](classopae_1_1fpga_1_1types_1_1not__supported.md) _exception_
    * **class** [**opae::fpga::types::reconf\_error**](classopae_1_1fpga_1_1types_1_1reconf__error.md) [_**reconf\_error**_](classopae_1_1fpga_1_1types_1_1reconf__error.md) _exception_
  * **class** [**opae::fpga::types::except**](classopae_1_1fpga_1_1types_1_1except.md) _Generic OPAE exception._   
    * **class** [**opae::fpga::types::busy**](classopae_1_1fpga_1_1types_1_1busy.md) _busy exception_ 
    * **class** [**opae::fpga::types::exception**](classopae_1_1fpga_1_1types_1_1exception.md) _exception exception_ 
    * **class** [**opae::fpga::types::invalid\_param**](classopae_1_1fpga_1_1types_1_1invalid__param.md) [_**invalid\_param**_](classopae_1_1fpga_1_1types_1_1invalid__param.md) _exception_
    * **class** [**opae::fpga::types::no\_access**](classopae_1_1fpga_1_1types_1_1no__access.md) [_**no\_access**_](classopae_1_1fpga_1_1types_1_1no__access.md) _exception_
    * **class** [**opae::fpga::types::no\_daemon**](classopae_1_1fpga_1_1types_1_1no__daemon.md) [_**no\_daemon**_](classopae_1_1fpga_1_1types_1_1no__daemon.md) _exception_
    * **class** [**opae::fpga::types::no\_driver**](classopae_1_1fpga_1_1types_1_1no__driver.md) [_**no\_driver**_](classopae_1_1fpga_1_1types_1_1no__driver.md) _exception_
    * **class** [**opae::fpga::types::no\_memory**](classopae_1_1fpga_1_1types_1_1no__memory.md) [_**no\_memory**_](classopae_1_1fpga_1_1types_1_1no__memory.md) _exception_
    * **class** [**opae::fpga::types::not\_found**](classopae_1_1fpga_1_1types_1_1not__found.md) [_**not\_found**_](classopae_1_1fpga_1_1types_1_1not__found.md) _exception_
    * **class** [**opae::fpga::types::not\_supported**](classopae_1_1fpga_1_1types_1_1not__supported.md) [_**not\_supported**_](classopae_1_1fpga_1_1types_1_1not__supported.md) _exception_
    * **class** [**opae::fpga::types::reconf\_error**](classopae_1_1fpga_1_1types_1_1reconf__error.md) [_**reconf\_error**_](classopae_1_1fpga_1_1types_1_1reconf__error.md) _exception_
  * **class** [**opae::fpga::types::except**](classopae_1_1fpga_1_1types_1_1except.md) _Generic OPAE exception._   
    * **class** [**opae::fpga::types::busy**](classopae_1_1fpga_1_1types_1_1busy.md) _busy exception_ 
    * **class** [**opae::fpga::types::exception**](classopae_1_1fpga_1_1types_1_1exception.md) _exception exception_ 
    * **class** [**opae::fpga::types::invalid\_param**](classopae_1_1fpga_1_1types_1_1invalid__param.md) [_**invalid\_param**_](classopae_1_1fpga_1_1types_1_1invalid__param.md) _exception_
    * **class** [**opae::fpga::types::no\_access**](classopae_1_1fpga_1_1types_1_1no__access.md) [_**no\_access**_](classopae_1_1fpga_1_1types_1_1no__access.md) _exception_
    * **class** [**opae::fpga::types::no\_daemon**](classopae_1_1fpga_1_1types_1_1no__daemon.md) [_**no\_daemon**_](classopae_1_1fpga_1_1types_1_1no__daemon.md) _exception_
    * **class** [**opae::fpga::types::no\_driver**](classopae_1_1fpga_1_1types_1_1no__driver.md) [_**no\_driver**_](classopae_1_1fpga_1_1types_1_1no__driver.md) _exception_
    * **class** [**opae::fpga::types::no\_memory**](classopae_1_1fpga_1_1types_1_1no__memory.md) [_**no\_memory**_](classopae_1_1fpga_1_1types_1_1no__memory.md) _exception_
    * **class** [**opae::fpga::types::not\_found**](classopae_1_1fpga_1_1types_1_1not__found.md) [_**not\_found**_](classopae_1_1fpga_1_1types_1_1not__found.md) _exception_
    * **class** [**opae::fpga::types::not\_supported**](classopae_1_1fpga_1_1types_1_1not__supported.md) [_**not\_supported**_](classopae_1_1fpga_1_1types_1_1not__supported.md) _exception_
    * **class** [**opae::fpga::types::reconf\_error**](classopae_1_1fpga_1_1types_1_1reconf__error.md) [_**reconf\_error**_](classopae_1_1fpga_1_1types_1_1reconf__error.md) _exception_